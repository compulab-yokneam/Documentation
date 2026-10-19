Use this workflow for a new **4 GiB** profile named `lpddr4_timing_newchip_4G.c`.

1. **Generate timings for the actual chip and board**

   Use the DDR tool with the correct chip geometry, ranks, board routing, frequencies, and electrical settings. Retain the tool project and an untouched copy of its generated C file.

   From the clone’s source root:

   ```bash
   ddr_dir=board/compulab/plat/imx8mp/ddr
   ddr_chip=newchip_4G
   ddr_mr58=0x12345678
   ddr_timing_file=${ddr_dir}/raw/lpddr4_timing_${ddr_chip}.c
   ddr_timing_struct=ucm_dram_timing_${ddr_chip}

   cp /path/to/generated/lpddr4_timing.c "${ddr_timing_file}"
   ```

   **`raw/` contains the editable inputs.** The top-level timing files are generated compact outputs.

2. **Modify the raw timing file**

   2.1. **Make all stractures staic**
   
   ```bash
   sed -i "s/struct/static struct/g" ${ddr_timing_file}
   ```

   2.2. **Rename the raw timing descriptor**

   ```bash
   sed -i "s/static \(struct dram_timing_info\) .* =/\1 ${ddr_timing_struct} = /g" ${ddr_timing_file}
   ```

   Keep all generated register values, entry order, FSP messages, frequencies, firmware types, and count expressions.

   Keep the generated trained-CSR array in this raw file. The packer automatically excludes its unused per-profile copy from compiled storage.

4. **Generate the compact files**

   ```bash
   python3 "$ddr_dir/pack.py"
   python3 "$ddr_dir/pack.py" --check
   ```

   This creates the top-level profile and updates the shared compact pool:

   ```text
   ddr/lpddr4_timing_${ddr_chip}.c
   ddr/lpddr4_compact_tables.c
   ddr/lpddr4_compact_tables.h
   ```

   Do not manually edit these generated files. For subsequent timing changes, edit the raw input and regenerate.

5. **Add the profile to the Makefile**

   In `$ddr_dir/Makefile`, add the generated text:

   ```bash
   cat << eof
   obj-$(CONFIG_SPL_BUILD) += lpddr4_timing_${ddr_chip}.o
   eof
   ```

   This compiles the generated top-level file; the raw file remains outside the build.

6. **Declare the generated descriptor**

   In `$ddr_dir/ddr.h`, inside its `CONFIG_SPL_BUILD` declaration block, add the generated text:

   ```bash
   cat << eof
   extern const struct dram_compact_timing ucm_dram_timing_${ddr_chip};
   eof
   ```

   Notice the distinction:

   | Location | Descriptor type |
   |---|---|
   | Raw generator input | `struct dram_timing_info` |
   | Generated compact output and declaration | `const struct dram_compact_timing` |

7. **Register the chip identity**

   Add an entry inside the existing `CONFIG_DRAM_D4` section of the regular `lpddr4_array` add the generated fragment:

   ```bash
   cat << eof
   {
       .name = "${ddr_chip}",
       .id = ${ddr_mr58}, /* Example: replace with the actual MR ID. */
       .subind = 0x4,
       .size = 4096,
       .count = 1,
   #ifdef CONFIG_SPL_BUILD
       .timing = &${ddr_timing_struct}
   #endif
   },
   eof
   ```

   Check these fields carefully:

   - `name`: at most 15 characters plus the terminating zero.
   - `id`: actual extracted MR5–MR8 identity.
   - `subind`: persistent profile discriminator; existing 4 GiB profiles conventionally use `0x4`.
   - `size`: total assembled memory in MiB.
   - `count`: follow the applicable assembly metadata.
   - `timing`: the new descriptor’s address.

   The identity is:

   ```c
   id = (MR5 << 24) | (MR6 << 16) | (MR7 << 8) | MR8;
   ```

   **Do not create different profiles with an indistinguishable ID/`subind` pair.** Resolve any collision deliberately, including compatibility with existing EEPROM records. Preserve discovery order unless changing it is intentional.

   Falcon/`SPL_OS_BOOT` has a separate descriptor list; update it only if this assembly must support that boot mode.

8. **Run the checks**

   ```bash
   python3 "$ddr_dir/pack.py" --check
   python3 test/compulab/test_ddr_compact.py
   python3 test/compulab/test_ddr_compact_phy.py
   python3 test/compulab/test_mrr_probe.py
   python3 test/compulab/test_ddr_discovery.py
   git diff --check
   ```

   These verify decoded tables, write order, saved timing layout, PHY execution, probing, and discovery behavior. Electrical validation still requires the board.

9. **Build with the required capacity enabled**

   For example, for SBEV with D2/D4 support:

   ```bash
   build_dir=/tmp/uboot-newchip

   make O="$build_dir" CROSS_COMPILE=aarch64-linux-gnu- \
       ucm-imx8m-plus-sbev_defconfig d2d4.config

   make O="$build_dir" CROSS_COMPILE=aarch64-linux-gnu- \
       -j8 spl/u-boot-spl

   aarch64-linux-gnu-size "$build_dir/spl/u-boot-spl"
   ```

   Substitute your actual compiler and board defconfig. Use `d1d8.config` for a new 1 or 8 GiB assembly.

   Once the firmware inputs are configured as in your working build, assemble the complete image using the existing BSP process or its `flash.bin` target. SPL alone is not a complete boot image.

10. **Validate the new assembly**

   Confirm the selected profile, MR identity, operating frequency, and memory capacity. Then test memory integrity, cold boot, warm resets, Linux boot, and suspend/resume.

   A valid EEPROM record normally bypasses discovery. Use the established EEPROM service procedure when testing fresh discovery.

   The optional MR probe cannot distinguish every duplicate identity or inconclusive rank response; those cases retain normal discovery.

Include the raw input, generated files, Makefile registration, and `ddr.h` changes together when committing. Record the chip part number, board revision, tool/firmware versions, build configuration, and hardware results.

The checked-in [compact timing guide](https://github.com/compulab-yokneam/u-boot-compulab/blob/u-boot-compulab_v2023.04-d1d8_d2d4-devel/board/compulab/plat/imx8mp/ddr/compact-timings.rst) documents this workflow.
