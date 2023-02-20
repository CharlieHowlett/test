--/**************************************************************************************************************
--*  Script to track Activity volumes from 1st September 2022 - split between campaign groups
--*  This script mirrors other Activity script but is focused on the 1st September 2022 onwards
--*  to cover the period of the Autumn Booster campaign.  Deaths are *NOT* removed from numerator as they 
--*  were vaccinations given. Age not based on 365.25 as gives errors [PCS 2022-10-13]
--*************************************************************************************************************/
-- Activity

SELECT PRS_PRIORITY_GROUP
--	/* Split Priority Groups by age etc...  Age based on 31/03/2023 */
   ,CASE
		when [PRS_PRIORITY_GROUP] = 'P0.1' Then 'P00.1 Severely Immunosuppressed (Scheduled)'                   
		when [PRS_PRIORITY_GROUP] = 'P0.2' Then 'P00.2 Severely Immunosuppressed (Manual)' 
		when [PRS_PRIORITY_GROUP] = 'P0.3' Then 'P00.3 Currently Immunosuppressed'                     
		when [PRS_PRIORITY_GROUP] = 'P1.1' Then 'P01.1 Care Home Residents'            
		when [PRS_PRIORITY_GROUP] = 'P1.2' Then 'P01.2 Care Home Worker'               
		when [PRS_PRIORITY_GROUP] = 'P2.1' Then 'P02.1 80 years and older' 
		when [PRS_PRIORITY_GROUP] = 'P2.2' Then 'P02.2 Health Care Worker'             
		when [PRS_PRIORITY_GROUP] = 'P2.3' Then 'P02.3 Social Care Worker'                        
		when [PRS_PRIORITY_GROUP] = 'P3' Then 'P03 Aged 75-79 years'
		when [PRS_PRIORITY_GROUP] = 'P4.1' Then 'P04.1 Aged 70-74 years' 
		when [PRS_PRIORITY_GROUP] = 'P4.2' Then 'P04.2 Clinically extremely vulnerable aged 16-69 years'    
		when [PRS_PRIORITY_GROUP] = 'P5' Then 'P05 Aged 65-69 years'
		when [PRS_PRIORITY_GROUP] = 'P6.1' Then 'P06.1 COPD'
		when [PRS_PRIORITY_GROUP] = 'P7' Then  'P07 Aged 60-64 years'            
		when [PRS_PRIORITY_GROUP] = 'P8' Then 'P08 Aged 55-59 years'            
		when [PRS_PRIORITY_GROUP] = 'P9' Then 'P09 Aged 50-54 years'        
		when [PRS_PRIORITY_GROUP] = 'P10' Then 
		CASE       
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 40 AND 49 THEN 'P10.1 Aged 40-49 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 30 AND 39 THEN 'P10.2 Aged 30-39 years' 
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 18 AND 29 THEN 'P10.3 Aged 18-29 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 16 AND 17 THEN 'P10.4 Aged 16-17 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 12 AND 15 THEN 'P10.5 Aged 12-15 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11 THEN 'P10.6 Aged 5-11 years' 
			ELSE 'P10.9 Rest Of Population' END
		WHEN [PRS_PRIORITY_GROUP] = 'P6' Then
		CASE
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11 THEN 'P06.6 Moderate risk children 5-11 years of age'                
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 12 AND 15 THEN 'P06.5 Moderate risk children 12-15 years of age'   
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 16 AND 64 THEN 'P06.4 Moderate risk adults 16 to under 65 years of age'   
			ELSE 'P06.9 - Other' END        
	else 'Invalid'+[PRS_PRIORITY_GROUP]      
	end as [PriorityGroupDescription]

	,[VaccinatingLHBName]= case
	when [WIS_PATIENT_AREA] = '7A1' then 'Betsi Cadwaladr ULHB'
	when [WIS_PATIENT_AREA] = '7A2' then 'Hywel Dda ULHB'
	when [WIS_PATIENT_AREA] = '7A3' then 'Swansea Bay ULHB'
	when [WIS_PATIENT_AREA] = '7A4' then 'Cardiff & Vale ULHB'
	when [WIS_PATIENT_AREA] = '7A5' then 'Cwm Taf Morgannwg ULHB'
	when [WIS_PATIENT_AREA] = '7A6' then 'Aneurin Bevan ULHB'
	when [WIS_PATIENT_AREA] = '7A7' then 'Powys Teaching LHB'
	else 'Velindre NHS Trust/Other' end

--	/* Campaign group logic during the autumn period (from the 1st September 2022 to 31st March 2023) 
--		age calculated as at end of March 2023, logic only relevant from 1st September */
	,CASE
		WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11
			and VACC_DATE_OF_VACCINE >= '2022-01-17 00:00:00.000' 
			and PRS_PRIORITY_GROUP IN ('P6','P0.1','P0.2','P0.3')
			THEN 'Aged 5-11 years children' --/* At risk 5-11yrs */
		WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11
			and VACC_DATE_OF_VACCINE >= '2022-03-07 00:00:00.000'
			and PRS_PRIORITY_GROUP = 'P10'
			AND CAST(PRS_DATE_OF_BIRTH as date) <= '2017-08-31'
			THEN 'Aged 5-11 years children'	--/* healthy 5-11yrs */
		WHEN DOSE_SEQUENCE not in ('1','2','3') 
			and VACC_DATE_OF_VACCINE >= '2022-09-01 00:00:00.000' 
			AND [PRS_PRIORITY_GROUP] NOT IN ('P10')
			THEN 'Autumn Booster'  --/* Autumn Booster */
		WHEN VACC_DATE_OF_VACCINE >= '2022-09-01 00:00:00.000'
			AND (
				(DOSE_SEQUENCE IN ('1','2') AND CAST(PRS_DATE_OF_BIRTH as date) <= '2017-08-31')
				OR
				(DOSE_SEQUENCE IN ('3') AND [PRS_PRIORITY_GROUP] IN ('P0.1','P0.2','P0.3'))
				OR
				(DOSE_SEQUENCE IN ('B1') AND (DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE 
												WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
													PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END >= 16
												OR (DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE 
														WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
															PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END >= 12
													AND	[PRS_PRIORITY_GROUP] IN ('P6'))))
				)
			THEN 'Leave no one behind' 
		ELSE 'Data Quality'
	END AS 'Campaign Group'
	,CAST(VACC_DATE_OF_VACCINE as date) AS VaccDate
	,DOSE_SEQUENCE
	,CASE
		WHEN DATEADD(DD, 2 - DATEPART(DW, DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10)))), DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10)))) = '2022-08-29' THEN '2022-09-01'
		ELSE DATEADD(DD, 2 - DATEPART(DW, DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10)))), DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10))))
	END as wkDate
	,count(*) as num

FROM [DW_Extracts].[acc].[WIS_OutcomeDataV2] 
WHERE 1=1
AND CAST(VACC_DATE_OF_VACCINE as date) >= '2022-09-01 00:00:00.000'
AND CAST(VACC_DATE_OF_VACCINE as date) < CAST(GETDATE() as date)
AND [PossibleDuplicateSameDay] IS NULL
AND [PossibleDuplicateWithin21Days] IS NULL
--AND VaccinationLocationType is not null (removed following discusision with Jon Walters 20/09/2022)
AND [APPT_OUTCOME] = '4'

GROUP BY PRS_PRIORITY_GROUP  
   ,CASE
		when [PRS_PRIORITY_GROUP] = 'P0.1' Then 'P00.1 Severely Immunosuppressed (Scheduled)'                   
		when [PRS_PRIORITY_GROUP] = 'P0.2' Then 'P00.2 Severely Immunosuppressed (Manual)' 
		when [PRS_PRIORITY_GROUP] = 'P0.3' Then 'P00.3 Currently Immunosuppressed'                     
		when [PRS_PRIORITY_GROUP] = 'P1.1' Then 'P01.1 Care Home Residents'            
		when [PRS_PRIORITY_GROUP] = 'P1.2' Then 'P01.2 Care Home Worker'               
		when [PRS_PRIORITY_GROUP] = 'P2.1' Then 'P02.1 80 years and older' 
		when [PRS_PRIORITY_GROUP] = 'P2.2' Then 'P02.2 Health Care Worker'             
		when [PRS_PRIORITY_GROUP] = 'P2.3' Then 'P02.3 Social Care Worker'                        
		when [PRS_PRIORITY_GROUP] = 'P3' Then 'P03 Aged 75-79 years'
		when [PRS_PRIORITY_GROUP] = 'P4.1' Then 'P04.1 Aged 70-74 years' 
		when [PRS_PRIORITY_GROUP] = 'P4.2' Then 'P04.2 Clinically extremely vulnerable aged 16-69 years'    
		when [PRS_PRIORITY_GROUP] = 'P5' Then 'P05 Aged 65-69 years'
		when [PRS_PRIORITY_GROUP] = 'P6.1' Then 'P06.1 COPD'
		when [PRS_PRIORITY_GROUP] = 'P7' Then  'P07 Aged 60-64 years'            
		when [PRS_PRIORITY_GROUP] = 'P8' Then 'P08 Aged 55-59 years'            
		when [PRS_PRIORITY_GROUP] = 'P9' Then 'P09 Aged 50-54 years'        
		when [PRS_PRIORITY_GROUP] = 'P10' Then 
		CASE       
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 40 AND 49 THEN 'P10.1 Aged 40-49 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 30 AND 39 THEN 'P10.2 Aged 30-39 years' 
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 18 AND 29 THEN 'P10.3 Aged 18-29 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 16 AND 17 THEN 'P10.4 Aged 16-17 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 12 AND 15 THEN 'P10.5 Aged 12-15 years'
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11 THEN 'P10.6 Aged 5-11 years' 
			ELSE 'P10.9 Rest Of Population' END
		WHEN [PRS_PRIORITY_GROUP] = 'P6' Then
		CASE
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11 THEN 'P06.6 Moderate risk children 5-11 years of age'                
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 12 AND 15 THEN 'P06.5 Moderate risk children 12-15 years of age'   
			WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 16 AND 64 THEN 'P06.4 Moderate risk adults 16 to under 65 years of age'   
			ELSE 'P06.9 - Other' END        
	else 'Invalid'+[PRS_PRIORITY_GROUP]    
	end

	,case
	when [WIS_PATIENT_AREA] = '7A1' then 'Betsi Cadwaladr ULHB'
	when [WIS_PATIENT_AREA] = '7A2' then 'Hywel Dda ULHB'
	when [WIS_PATIENT_AREA] = '7A3' then 'Swansea Bay ULHB'
	when [WIS_PATIENT_AREA] = '7A4' then 'Cardiff & Vale ULHB'
	when [WIS_PATIENT_AREA] = '7A5' then 'Cwm Taf Morgannwg ULHB'
	when [WIS_PATIENT_AREA] = '7A6' then 'Aneurin Bevan ULHB'
	when [WIS_PATIENT_AREA] = '7A7' then 'Powys Teaching LHB'
	else 'Velindre NHS Trust/Other' end
	
	,CASE
		WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11
			and VACC_DATE_OF_VACCINE >= '2022-01-17 00:00:00.000' 
			and PRS_PRIORITY_GROUP IN ('P6','P0.1','P0.2','P0.3')
			THEN 'Aged 5-11 years children' --/* At risk 5-11yrs */
		WHEN DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
				 PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END between 5 AND 11
			and VACC_DATE_OF_VACCINE >= '2022-03-07 00:00:00.000'
			and PRS_PRIORITY_GROUP = 'P10'
			AND CAST(PRS_DATE_OF_BIRTH as date) <= '2017-08-31'
			THEN 'Aged 5-11 years children'	--/* healthy 5-11yrs */
		WHEN DOSE_SEQUENCE not in ('1','2','3') 
			and VACC_DATE_OF_VACCINE >= '2022-09-01 00:00:00.000' 
			AND [PRS_PRIORITY_GROUP] NOT IN ('P10')
			THEN 'Autumn Booster'  --/* Autumn Booster */
		WHEN VACC_DATE_OF_VACCINE >= '2022-09-01 00:00:00.000'
			AND (
				(DOSE_SEQUENCE IN ('1','2') AND CAST(PRS_DATE_OF_BIRTH as date) <= '2017-08-31')
				OR
				(DOSE_SEQUENCE IN ('3') AND [PRS_PRIORITY_GROUP] IN ('P0.1','P0.2','P0.3'))
				OR
				(DOSE_SEQUENCE IN ('B1') AND (DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE 
												WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
													PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END >= 16
												OR (DATEDIFF(YY, PRS_DATE_OF_BIRTH, '2023-03-31') + CASE 
														WHEN (DATEADD(YY,2023-DATEPART(YY, PRS_DATE_OF_BIRTH),
															PRS_DATE_OF_BIRTH) > '2023-03-31') THEN - 1 ELSE 0 END >= 12
													AND	[PRS_PRIORITY_GROUP] IN ('P6'))))
				)
			THEN 'Leave no one behind' 
		ELSE 'Data Quality'
	END
	,CAST(VACC_DATE_OF_VACCINE as date)
	,DOSE_SEQUENCE
	,CASE
		WHEN DATEADD(DD, 2 - DATEPART(DW, DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10)))), DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10)))) = '2022-08-29' THEN '2022-09-01'
		ELSE DATEADD(DD, 2 - DATEPART(DW, DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10)))), DATEADD(DD, -1, CONVERT(DATE,RIGHT(VACC_DATE_OF_VACCINE,10))))
	END	
