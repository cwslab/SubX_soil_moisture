;---plot ADD for regridded ERA-5& CESM2 CAM6  distribution figure
begin
 ;--- lat 77* lon 81 * lead 46
 ; lat 25*lon 46*lead 46*season 4
 accID1    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/drought_flood/Corre_combineSM_CAM6_0_45_leaddays_4_seasons_normalized_1999_2018_flood_05.nc","r")
 accID2    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/drought_flood/Corre_combineSM_CAM6climoLND_0_45_leaddays_4_seasons_normalized_1999_2018_flood_05.nc","r")
 ;accID3    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/drought_flood/Corre_combineSM_CAM6_0_45_leaddays_4_seasons_normalized_1999_2018_flood_05.nc","r")
 accID4    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/drought_flood/Corre_combineSM_CAM6climoOCNclimoATMv2_0_45_leaddays_4_seasons_normalized_1999_2018_flood_05.nc","r")
 
 corre_yr0 = accID1->corre_sn
 ; lat 25*lon 46*season 4*kind 4
 corre_yr  = new((/25,46,4,3/),"float",corre_yr0@_FillValue)

 corre_yr(:,:,:,0) = accID1->corre_sn(:,:,21,:)
 corre_yr(:,:,:,1) = accID2->corre_sn(:,:,21,:)
 corre_yr(:,:,:,2) = accID4->corre_sn(:,:,21,:)
 ;corre_yr(:,:,:,3) = accID4->corre_sn(:,:,21,:)

 ;corre_yr(:,:,:,2) = corre_yr(:,:,:,0)-corre_yr(:,:,:,1)
 ;corre_yr(:,:,:,3) = corre_yr(:,:,:,0)-corre_yr(:,:,:,3)

 ;corre_yr  = (/corre_yr^2/)

 ;corre_yr = mask(corre_yr, (corre_yr.gt.0), True)

 corre_yr_sig          = corre_yr
 corre_yr_sig(:,:,:,0) = accID1->corre_sn_sig(:,:,21,:)
 corre_yr_sig(:,:,:,1) = accID2->corre_sn_sig(:,:,21,:)
 corre_yr_sig(:,:,:,2) = accID4->corre_sn_sig(:,:,21,:)
 ;print(avg(corre_yr_sig(:,:,:,2)))

 ;exit

 ;corre_yr_sig(:,:,:,3) = accID4->corre_sn_sig(:,:,21,:)
 ;corre_yr_sig(:,:,:,2) = 100 

 corre_yr_sig_P = where(corre_yr_sig.lt.0.05,1,0)
 corre_yr_sig   = (/corre_yr_sig_P/) 
 ;corre_yr_sig(24,45,:,2) = 0.7
 



 corre_yr_sig = mask(corre_yr_sig, (corre_yr.gt.0), True)

 ;--- lat 77*lon 81
 lat = accID1->lat
 lon = accID1->lon

 wgt = latRegWgt(lat, "float", 0)


 neon_file = "/glade/work/yanand/USDA_FACT/Corre_Fig_H2OSOI/NEON_site_shapefile/NEON16_final1_gcs.shp"

 fm = addfile("/glade/u/home/kumar34/neon21/neon17_mask_CLM1deg.nc", "r")

 neon_mask = fm->neon_mask(:, {25.91:48.54}, {236.25:292.5})

 printVarSummary(neon_mask)


  P2 = new((/72, 4/), "float", -9999.0)



;exit


;**************PLOT GRID GRAPH*******************************************************************
wks_type = "png"
wks_type@wkWidth = 3000
wks_type@wkHeight = 3000 
wks  = gsn_open_wks(wks_type, "Fig5_flood_npj_rev1_plot")
;wks  = gsn_open_wks("x11","Corre_combineSM_cesm2cam6v2_14_27_lead_flood_4_season_NEON_region_normalized_CTRL_ATMOCN_LND_rev2")              ; send graphics to PNG file
 res                           = True              
 res@mpMinLatF                 = 24                ; zoom in on map
 res@mpMaxLatF                 = 50
 res@mpMinLonF                 = -125.5
 res@mpMaxLonF                 = -65.5

 res@mpOutlineBoundarySets     = "Geophysical"; turn on states
 res@mpUSStateLineColor        = "black"
 res@mpDataBaseVersion         = "MediumRes"             ; select database
 res@mpDataSetName             = "Earth..2"
 res@mpFillBoundarySets        = "USStates"
 res@mpOutlineOn               = True

 res@cnConstFLabelString = ""  
 res@cnConstFLabelFontHeightF = 0.0
 
 res@mpFillAreaSpecifiers  = (/"United States", "Mexico"/)
 ;res@mpMaskAreaSpecifiers  =  (/"Mexico"/)
 res@mpSpecifiedFillColors = (/"transparent","white"/)

 res@gsnDraw                   = False                  ; don't draw
 res@gsnFrame                  = False                  ; don't advance frame
 res@gsnAddCyclic              = False

 res@pmTickMarkDisplayMode = "Always" ;Add map lon lat mark

 res@cnFillOn = True
 res@cnLinesOn = False
 ;res@cnFillMode = "RasterFill"
 res@cnLineLabelsOn = False
 res@cnFillDrawOrder = "Predraw"
 res@cnLineDrawOrder = "Predraw"

 res@cnLevelSelectionMode = "ManualLevels"
 res@cnMinLevelValF = -0.9
 res@cnMaxLevelValF = 0.9
 res@cnLevelSpacingF = 0.15
 res@gsnSpreadColors = True

; res@cnLevelSelectionMode = "ExplicitLevels"
; res@cnLevels = (/0,0.025,0.05,0.075,0.1,0.15,0.2,0.3,0.4/)
; res@cnFillPalette = "CBR_wet"
; res@vcLevelPalette = "CBR_wet"

 res@lbLabelBarOn = False
 ;HoriTitle = (/"CTRL drought","ATM+OCN drought","CTRL-(ATM+OCN) drought","CTRL-LND drought"/)
 HoriTitle = (/"ATM+LND+OCN flood","ATM+OCN flood","LND flood"/)
 VertTitle = (/"MAM", "JJA", "SON","DJF"/)

 res@tiMainOffsetYF = -0.007
 res@tiMainFontHeightF = 0.03

 ;--------------------------
 res@tmYROn = False
 res@tmYLOn = False
 res@tmXTOn = False
 res@tmXBOn = False
 ;--------------------------
 
 plots = new((/4,3/), graphic)
 acc_us = new((/4, 3/), "float", -99.0)


 gsn_define_colormap(wks,"GreenMagenta16")

 res@tiYAxisOn = True
 res@tiYAxisString = VertTitle(0)
 res@tiYAxisOffsetYF = 0
 res@tiYAxisOffsetXF = 0.008
 res@tiYAxisFontHeightF = 0.03
 
 do kindj = 0, 0
  res@tiMainString = HoriTitle(kindj)
  plots(0,kindj) = gsn_csm_contour_map(wks, corre_yr(:,:,0,kindj), res)
  acc_us(0, kindj) = wgt_areaave(corre_yr(:,:,0,kindj), wgt, 1.0, 0)

   do r = 0, 16
    temp_neon = neon_mask(r, :, :)
    temp_corr = mask(corre_yr(:,:,0,kindj), temp_neon.eq.1, True)
    P2(r, kindj) = wgt_areaave(temp_corr, wgt, 1.0, 0)
    delete(temp_neon)
    delete(temp_corr)
  end do





 end do

 res@tiYAxisOn = False
 do kindj = 1, 2
  res@tiMainString = HoriTitle(kindj)
  plots(0,kindj) = gsn_csm_contour_map(wks, corre_yr(:,:,0,kindj), res)
  acc_us(0, kindj) = wgt_areaave(corre_yr(:,:,0, kindj), wgt, 1.0, 0)

   do r = 0, 16
    temp_neon = neon_mask(r, :, :)
    temp_corr = mask(corre_yr(:,:,0,kindj), temp_neon.eq.1, True)
    P2(r, kindj) = wgt_areaave(temp_corr, wgt, 1.0, 0)

    delete(temp_neon)
    delete(temp_corr)

  end do




 end do

 res@tiYAxisOn = True
 res@tiMainOn  = False

 res@tiYAxisString = VertTitle(1)
 plots(1,0) = gsn_csm_contour_map(wks, corre_yr(:,:,1,0), res)
 acc_us(1, 0) = wgt_areaave(corre_yr(:,:,1,0), wgt, 1.0, 0)



   do r = 0, 16
    temp_neon = neon_mask(r, :, :)
    temp_corr = mask(corre_yr(:,:,1, 0), temp_neon.eq.1, True)
    P2(r+18, 0) = wgt_areaave(temp_corr, wgt, 1.0, 0)
    delete(temp_neon)
    delete(temp_corr)
  end do






 res@tiYAxisString = VertTitle(2)
 plots(2,0) = gsn_csm_contour_map(wks, corre_yr(:,:,2,0), res)
 acc_us(2, 0) = wgt_areaave(corre_yr(:,:,2,0), wgt, 1.0, 0)


   do r = 0, 16
    temp_neon = neon_mask(r, :, :)
    temp_corr = mask(corre_yr(:,:,2, 0), temp_neon.eq.1, True)
    P2(r+36, 0) = wgt_areaave(temp_corr, wgt, 1.0, 0)
    delete(temp_neon)
    delete(temp_corr)
  end do






 res@tiYAxisString = VertTitle(3)
 plots(3,0) = gsn_csm_contour_map(wks, corre_yr(:,:,3,0), res)
 acc_us(3, 0) = wgt_areaave(corre_yr(:,:,3,0), wgt, 1.0, 0)

  do r = 0, 16
    temp_neon := neon_mask(r, :, :)
    temp_corr := mask(corre_yr(:,:,3, 0), temp_neon.eq.1, True)
    P2(r+54, 0) = wgt_areaave(temp_corr, wgt, 1.0, 0)
    delete(temp_neon)
    delete(temp_corr)

  end do






 res@tiYAxisOn = False 

 res@tiMainOn = False
 do seai = 1, 3
  do kindj = 1, 2
   if ((seai.eq.3).and.(kindj.eq.1)) then
     ;res@lbOrientation = "Vertical"

     res@lbLabelBarOn = True
     res@lbBoxLinesOn = False            ; Turn off labelbar box lines
     res@lbLabelAutoStride = True        ; Control labelbar labels.
     res@pmLabelBarWidthF  = 2.3
     res@lbLabelFontHeightF = 0.035
     res@pmLabelBarHeightF  = 0.12
     res@lbBottomMarginF = -0.2
   end if
   plots(seai,kindj) = gsn_csm_contour_map(wks, corre_yr(:,:,seai,kindj), res)
   acc_us(seai, kindj) = wgt_areaave(corre_yr(:,:,seai,kindj), wgt, 1.0, 0)

   res@lbLabelBarOn = False


    do r = 0, 16
       temp_neon = neon_mask(r, :, :)
       temp_corr = mask(corre_yr(:,:,seai, kindj), temp_neon.eq.1, True)
       P2(r+18*seai, kindj) = wgt_areaave(temp_corr, wgt, 1.0, 0)

       delete(temp_neon)
       delete(temp_corr)

   end do

  end do
 end do


 opt11 = True
 opt11@fout = "flood_pred_NEON_eco.txt"
 fmtx = "4f11.4"
 write_matrix(P2, fmtx, opt11)





 ;----------- plot significant area -------------------
 res2 = True
 res2@gsnDraw            = False             ; don't draw yet
 res2@gsnFrame           = False             ; don't advance fra

 res2@gsnAddCyclic = False
 res2@gsnMaximize  = True

 res2@cnInfoLabelOn       = False       ; turn off info label
 res2@cnLinesOn           = False       ; do not draw contour lines
 res2@cnLineLabelsOn      = False       ; do not draw contour labels
 res2@cnConstFEnableFill  = True         ; Fill even scalar field is constant
 res2@cnFillScaleF        = 0.6         ; add extra density
 res2@cnFillDotSizeF = 0.0018

 res2@cnFillDrawOrder = "Predraw"
 res2@cnLineDrawOrder = "Predraw"

 res2@cnLevelSelectionMode = "ManualLevels"
 res2@cnMinLevelValF  =  0.2 
 res2@cnMaxLevelValF  =  1.0
 res2@cnLevelSpacingF =  0.1

 opt = True
 opt@gsnShadeFillType = "pattern"       ; pattern fill
 opt@gsnShadeHigh = 17                  ; use pattern #2
 ;opt@gsnShadeLow  = 17
 res2@cnConstFEnableFill = True        ; Fill even scalar field is constant
 
 ;-------------------------------------------------------
 plots2 = new((/4,3/), graphic)
 do seai = 0, 3
  do kindj  = 0, 2
    ;if (kindj.ne.2) then
     plots2(seai,kindj) = gsn_csm_contour(wks, corre_yr_sig(:,:,seai,kindj), res2)
     plots2(seai,kindj) = gsn_contour_shade(plots2(seai,kindj), -0.2, 0.8, opt)

     overlay(plots(seai,kindj), plots2(seai,kindj))
     ;print(seai)
     ;print(kindj)
    ;end if
  end do
 end do

 plot1d = ndtooned(plots) 

 acc_us1d = ndtooned(acc_us)


   acc_us_num = new(12, "string")


 ;pan_num = (/"[a]", "[b]", "[c]", "[d]", "[e]", "[f]", "[g]", "[h]", "[i]", "[j]", "[k]", "[l]"/)

 pan_num = (/"[m]", "[n]", "[o]", "[p]", "[q]", "[r]", "[s]", "[t]", "[u]", "[v]", "[w]", "[x]"/)


 do i = 0, 11

    acc_us_num(i) = pan_num(i)+" "+sprintf("%2.2f", acc_us1d(i))

 end do




 ;------------------define mpres-------------------------------
 pres                  = True
 pres@gsLineThicknessF = 1.5
 pres@gsLineColor      = "black"
 poly = new(16, "graphic")
 
 do i = 0, 11
   poly(i) = gsn_add_shapefile_polylines(wks,plot1d(i),neon_file,pres)
 end do
 
 ;---Panel Plotting---
  resP = True
 ;resP@gsnPanelLabelBar = True                ; add common colorbar
 resP@gsnMaximize = True
 resP@pmLabelBarWidthF  = 0.9
 resP@gsnPanelFigureStringsFontHeightF = 0.013
 ;resP@gsnPanelFigureStrings= (/"Lead 1-15 days", "Lead 16-30 days", "Lead 31-45 days"/) ; add strings to panel

 resP@gsnPanelFigureStrings = acc_us_num
 resP@tiMainString        = (/"CESM2(CAM6)"/)

 resP@gsnPanelFigureStringsPerimOn = False
 resP@amJust = "BottomLeft"
 ;resP@amParallelPosF=0.15
 ;resP@amOrthogonalPosF=-0.5
 resP@gsnPanelFigureStringsBackgroundFillColor = "white"
 resP@lbLabelFontHeightF  = 0.04               ; make labels smaller
 ;resP@gsnPanelYWhiteSpacePercent = 5
 gsn_panel(wks,plot1d ,(/4,3/),resP)


 gsn_panel(wks,plot1d ,(/4,3/),resP)

 frame(wks)

end
  
  
  
  
