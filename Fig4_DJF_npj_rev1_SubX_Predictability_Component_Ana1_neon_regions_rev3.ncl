load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"




 ;******setup files
 inDir = "/glade/work/yanand/USDA_FACT/combine_sm_obs/Corre_combineSM_cesm2cam6v2_0_45_leaddays_8_kinds_1999_2018_CONUS_NEON_seasons/"

 seas = 0

 pd_comp = new((/17, 8, 46/), "float", -9999.0)

 do i = 0, 16
    f1 = addfile(inDir+"Corre_combineSM_cesm2cam6v2_0_45_leaddays_8_kinds_1999_2018_CONUS_NEON"+(i+1)+"_seasons.nc", "r")
    var1 = f1->corre_sn(:, seas, :)

     do k = 0, 7
        pd_comp(i, k, :) = (/var1(:, k)/)
     end do

 end do 

 printVarSummary(pd_comp)


;**********************************************************

wks_type = "png"
wks_type@wkWidth = 3000
wks_type@wkHeight = 3000 
wks  = gsn_open_wks(wks_type, "Fig4_JJA_2_npj_rev1_plot")
;wks = gsn_open_wks("x11","predictability_componenet_soil_moisture_DJF_rev2")             ; send graphics to PNG file

  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet

  res@vpHeightF 	 = 0.4               ; change aspect ratio of plot
  res@vpWidthF 	         = 0.4
 
  res@trXMinF	         = 7              ; set x-axis minimum
  res@trXMaxF            = 39
  
  time1 = ispan(1, 46, 1)
  time2 = time1


  time1_lb = time1(0:5)
  time2_lb = time2(0:5)

  do i = 0, 5
     time1_lb(i) = time1((i+1)*7)
     time2_lb(i) = time2((i+1)*7)
  end do


  res@tmXBMode          = "Explicit"              ; explicit labels
  res@tmXBValues        = time1_lb                       ; location of labels
  res@tmXBLabels        = time1_lb                ; labels themselves

  res@trYMinF            = -0.2              ; set x-axis minimum
  res@trYMaxF            = 0.8
  
  res@xyMonoLineColor    = False             ; want colored lines


 res@tmXBLabelFontHeightF = 0.015
 res@tmYLLabelFontHeightF = 0.015

   
  nReg = 17

  plots = new(nReg, graphic)
  plots1 = plots
  plots2 = plots
  plots3 = plots
  plots_obs = plots

  time1 = ispan(1, 46, 1)

  ncomp = 8

  P1_temp = new((/ncomp, 46/), "float", -9999.0) 

  P2_temp = P1_temp(0:1, :)

  res@txtFontSizeF = 0.03 

 ;res@txFontHeightF = 0.02  ; Set the font size (adjust as needed)
 ;res@tyFontHeightF = 0.02  ; Set the font size for the y-axis (if needed)


  res1 = res

  res1@xyMonoLineColor    = False             ; want colored lines
  res1@xyLineColors       := (/"black", "red","seagreen", "blue", "yellow", "violet", "cyan4", "grey30"/) ; colors chosen
  res1@xyLineThicknesses  := (/3.,3., 3.0, 3.0, 3.0, 3.0, 3.0, 3.0/) *2.0     ; line thicknesses
  res1@xyDashPatterns     := (/0, 0, 0, 0, 16, 16, 16, 16/)      ; make all lines solid
  ;res1@gsLineDashPattern = (/0, 0, 0, 0, 1, 1, 1, 1/)
  ;res1@gsnDashIndex = 2



   pt1 = "$$$$$$$$$$$$$"
   pt2 = "$$$______$$$"
  
  pattern = (/pt1, pt1, pt1, pt1, pt2, pt2, pt2, pt2/)

  res1@xyDashPatterns := NhlNewDashPattern(wks,pattern)


 P2 = new((/17, 8/), "float", -9999.0)


 
 
 ; i = 0

 do i = 0, nReg-1
 

    P1_temp(0, :) = pd_comp(i, 0, :)
    P1_temp(1, :) = pd_comp(i, 4, :)
    P1_temp(2, :) = pd_comp(i, 5, :)
    P1_temp(3, :) = pd_comp(i, 6, :)
   
    P1_temp(4, :) = pd_comp(i, 5, :) - pd_comp(i, 7, :) - (pd_comp(i, 3, :) - pd_comp(i, 4, :))

    P1_temp(5, :) = pd_comp(i, 3, :) - pd_comp(i, 5, :) - (pd_comp(i, 0, :) - pd_comp(i, 1, :))

    P1_temp(6, :) = pd_comp(i, 3, :) - pd_comp(i, 4, :) - (pd_comp(i, 0, :) - pd_comp(i, 2, :))

    P1_temp(7, :) = pd_comp(i, 1, :) + pd_comp(i, 2, :) + pd_comp(i, 3, :) - pd_comp(i, 4, :) - pd_comp(i, 5, :) - pd_comp(i, 6, :) + pd_comp(i, 7, :)   

    P2(i, :) = dim_avg_n(P1_temp, 1)
   

    plots(i) = gsn_csm_xy (wks,time1,P1_temp(0:7, :),res1)       ; create line plot



   ; Create a plot with the area between both curves filled in blue.
   ;delete(res@xyLineColors)
   ;delete(res@xyDashPatterns)
   res@gsnXYFillOpacities = 0.2
   res@gsnXYFillColors = "cyan"
   res@xyLineColors     := (/-1, -1/)                           ; We don't want the line, so make it transparent.
  
   P2_temp(0, :) = 0.0
   P2_temp(1, :) = P1_temp(3,:)

   plots1(i)  = gsn_csm_xy (wks,time1, P2_temp,res)  ; Create filled XY plot.

; Create a plot with the area between both curves filled in pink.
   res@gsnXYFillColors = "violetred1"
   res@xyLineColors     = (/-1, -1/)
  
   P2_temp(0, :) = 0.0
   P2_temp(1, :) = P1_temp(1,:)

   plots2(i)  = gsn_csm_xy (wks,time1,P2_temp,res)  ; Create another filled XY plot.

   res@gsnXYFillColors = "green"
   P2_temp(0, :) = 0.0
   P2_temp(1, :) = P1_temp(2,:)
   plots3(i)  = gsn_csm_xy (wks,time1,P2_temp,res)
 
   overlay(plots(i), plots3(i))
   overlay(plots(i),plots2(i))
   overlay(plots(i),plots1(i))
  
   delete(res@gsnXYFillColors)
   delete(res@xyLineColors) 

  ;draw(plots(i))

end do


 opt1 = True
 opt1@fout = "pd_comp_eight_DJF.txt"
 fmtx = "8f15.8"
 write_matrix(P2, fmtx, opt1)
 

 NEON_NAME = new(17, string)

 do i = 0, 16
    NEON_NAME(i) = "NEON"+sprinti("%0.2i", i+1)
 end do
 
 NEON_NAME = NEON_NAME 


 pres                 = True
 ;pres@gsnPanelRowSpec = True
                        ; tell panel what order to plot
 pres@gsnPanelCenter  = False
 pres@gsnPanelRight = 1.0
 pres@gsnMaximize = True
 pres@gsnOrientation = "portrait"
 pres@gsnFrame = False
 

  
   pres@gsnPanelXF = (/0.83, 0.83, 0.83, 0.83, \
                       0.63, 0.43, 0.63, 0.63, \
		       0.43, 0.43, 0.43, \
		       0.23, 0.23, 0.03, 0.23, \
		       0.03, 0.03/)


 pres@gsnPanelYF = (/0.92, 0.72, 0.52, 0.32, 0.92, 0.72, 0.72, 0.52, 0.92, 0.52, 0.32, 0.92, 0.52, 0.52, 0.72, 0.92, 0.72/)

 pres@gsnPanelFigureStringsBackgroundFillColor = -1
 pres@gsnPanelFigureStringsPerimOn = False
 pres@gsnPanelFigureStrings = NEON_NAME
 pres@amJust = "TopRight"
 gsn_panel(wks,plots(0:16),(/4, 5/),pres)

 ;gsn_panel(wks,plots(0),(/1, 1/),pres)
 
 
    LC1       := (/"black", "red","seagreen", "blue", "yellow", "violet", "cyan4", "grey30"/) ; colors chosen
    LT1       := (/3.,3., 3.0, 3.0, 3.0, 3.0, 3.0, 3.0/) *2.0     ; line thicknesses
    DP1      := (/0, 0, 0, 0, 16, 16, 16, 16/)      ; make all lines solid
   
   res_text                    = True                  ; text mods desired
   res_text@txFontHeightF      = 0.015                 ; change text size
   res_text@txJust             = "CenterLeft"          ; text justification
   res_lines                   = True                  ; polyline mods desired
   
   x_pos = (/0.03, 0.03, 0.03, 0.03, 0.20, 0.20, 0.20, 0.20/)
   y_pos = (/0.30, 0.26, 0.22, 0.18, 0.30, 0.26, 0.22, 0.18/)
   
   
 
   pd_comp :=(/"Standard", "Atmos.","Land", "Ocean", "Coup_LA", "Coup_AO", "Coup_LO", "Sum"/) ; colors chosen   

 
    
    do i=0,7
       res_lines@gsLineDashPattern = DP1(i)                    ; solid line
       res_lines@gsLineThicknessF  =  LT1(i)                   ; line thicker
       res_lines@gsLineColor       = LC1(i)                ; line color
       xx = (/x_pos(i),x_pos(i)+0.05/)
       yy = (/y_pos(i),y_pos(i)/)
       gsn_polyline_ndc(wks,xx,yy,res_lines)              ; add polyline
       gsn_text_ndc(wks, pd_comp(i),x_pos(i)+0.07,y_pos(i),res_text); add text
    end do	

    ;gsn_text_ndc(wks, "forecast lead (in days)", 0.40, 0.10, res_text)


;draw(plots)
 frame(wks)





























