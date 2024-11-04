### SubX soil moisture
This folder contains the scripts (NCL) written for generating the fugures in the paper. The files are named according to the fgure they generate.
![Fig_1_final](https://github.com/user-attachments/assets/d5559b65-292b-422c-93ab-594ac090f6c3)


#### Figure 2:
**Data requirements**
- Corre_combineSM_CAM6climoOCNclimoLND_0_45_leaddays_4_seasons_normalized_1999_2018.nc
- Corre_combineSM_CAM6climoATMclimoLND_0_45_leaddays_4_seasons_normalized_1999_2018.nc
- Corre_combineSM_CAM6climoOCNclimoATMv2_0_45_leaddays_4_seasons_normalized_1999_2018.nc

Make sure you adjust the code to the path of the location o fthese datasets, then run the code here:

```
ncl Fig2b_m_npj_rev1_plot_combineSM_SubXCAM6_season_corre_1_14days_normalized_CONUS_NEON_site_1999_2018_remain_exp_rev1.ncl

```
#### Figure 3:
**Data requirements**
-  Corre_combineSM_CAM6_0_45_leaddays_normalized_1999_2018.nc
-  Corre_combineSM_CAM6climOCN_0_45_leaddays_normalized_1999_2018.nc
-  Corre_combineSM_CAM6climoOCNclimoATMv2_0_45_leaddays_normalized_1999_2018.nc
-  Corre_combineSM_CAM6climATM_0_45_leaddays_normalized_1999_2018.nc
-  Corre_combineSM_CAM6climLND_0_45_leaddays_normalized_1999_2018.nc

Then run the code here:

```
ncl Fig3_npj_rev1_plot_combineSM_SubXCAM6_SM_corre_0_45_days_normalized_CONUS_NEON_site_1999_2018_rev2.ncl'
```
#### Figure 4:
**Data requirements**
- Corre_combineSM_cesm2cam6v2_0_45_leaddays_8_kinds_1999_2018_CONUS_NEON_seasons

Run the code here:

```
ncl Fig4_DJF_npj_rev1_SubX_Predictability_Component_Ana1_neon_regions_rev3.ncl'
```
#### Figure 5:
**Data requirements**
- Corre_combineSM_CAM6_0_45_leaddays_4_seasons_normalized_1999_2018_drought_05.nc
- Corre_combineSM_CAM6climoLND_0_45_leaddays_4_seasons_normalized_1999_2018_drought_05.nc
- Corre_combineSM_CAM6climoOCNclimoATMv2_0_45_leaddays_4_seasons_normalized_1999_2018_drought_05.ncR
Run the code here:
```
ncl Fig5_drought_npj_rev1_plot_combineSM_SubXCAM6_season_corre_14_27days_normalized_CONUS_NEON_site_1999_2018_drought_CTRL_ATMOCN_DIFF_LND_rev2.ncl'
```
#### Figure 6:
**Data requirements**
- Corre_cesm2cam6v2_sm_prcp_lag_corre_0_45_leaddays_4_seasons_normalized.nc
Run the code here:

```
ncl Fig6_spatial_npj_rev1_plot_SubXCAM6_ESRL_sm_GPCP_prcp_corre_1_45_days_normalized_CONUS_NEON_site_1999_2021_rev3.ncl'
```
