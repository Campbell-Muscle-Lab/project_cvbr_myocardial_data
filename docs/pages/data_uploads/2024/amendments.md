---
layout: default
title: Amendments
has_children: false
parent: Data uploads
nav_order: 10
---

# Amendments

# October 2024

Discovered data for 2 specimen numbers has been uploaded with incorrect hashcodes


| Specimen number | Correct hashcode | Wrongly entered hashcode | Data files |
| --------------- | ---------------  |  ----------------------- | ---------- |
| 51791.3         | 81CD7            | 81CD1                    | repo/uploads/2024/Sept/1/expt_data/tubulin_collated_september24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/MyBPC_Ser273_collated_September24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/MyBPC_Ser282_collated_September24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/MyBPC_Ser302_collated_September24.xlsx |
| 84854.1         | 0D377            | 0D337                    | repo/uploads/2024/Sept/1/expt_data/tubulin_collated_september24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/TnI_PhosTag_collated_September24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/MyBPC_Ser273_collated_September24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/MyBPC_Ser282_collated_September24.xlsx |
|                 |                  |                          | repo/uploads/2024/Sept/1/expt_data/MyBPC_Ser302_collated_September24.xlsx |


This was fixed by:
+ Manually
  + Finding the incorrect rows in each of the above data files
  + Creating new upload files that contain only the rows in question
  + Fixing the hashcode in these new upload files
  + Saving all the files in `<repo>/amendments/2024/October/1`
  + Deleting in REDCap all entries for hashcodes
    + 81CD1
    + 0D337
  + Uploading the new data files containing the corrections
