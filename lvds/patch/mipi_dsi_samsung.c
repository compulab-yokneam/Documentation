diff --git a/drivers/video/fbdev/mxc/mipi_dsi_samsung.c b/drivers/video/fbdev/mxc/mipi_dsi_samsung.c
index fa0f5a0..cc9f97d 100644
--- a/drivers/video/fbdev/mxc/mipi_dsi_samsung.c
+++ b/drivers/video/fbdev/mxc/mipi_dsi_samsung.c
@@ -84,10 +84,10 @@ static struct mipi_dsi_match_lcd mipi_dsi_lcd_db[] = {
 	{
 	 "SN65DSI_default",
 	 {sn65dsi83_get_lcd_videomode, sn65dsi83_lcd_setup, sn65dsi83_lcd_start, sn65dsi83_lcd_stop},
-	{ MIPI_DSI_PMS(0x4268),
-	(MIPI_DSI_M_TLPXCTL(3) | MIPI_DSI_M_THSEXITCTL(5)),
-	(MIPI_DSI_M_TCLKPRPRCTL(3) | MIPI_DSI_M_TCLKZEROCTL(20) | MIPI_DSI_M_TCLKPOSTCTL(9) | MIPI_DSI_M_TCLKTRAILCTL(4)),
-	(MIPI_DSI_M_THSPRPRCTL(5) | MIPI_DSI_M_THSZEROCTL(6) | MIPI_DSI_M_THSTRAILCTL(7)) }
+	{ MIPI_DSI_PMS(0x4168),
+	(MIPI_DSI_M_TLPXCTL(2) | MIPI_DSI_M_THSEXITCTL(3)),
+	(MIPI_DSI_M_TCLKPRPRCTL(2) | MIPI_DSI_M_TCLKZEROCTL(11) | MIPI_DSI_M_TCLKPOSTCTL(8) | MIPI_DSI_M_TCLKTRAILCTL(3)),
+	(MIPI_DSI_M_THSPRPRCTL(2) | MIPI_DSI_M_THSZEROCTL(2) | MIPI_DSI_M_THSTRAILCTL(5)) }
 	},
 #endif
 	{
