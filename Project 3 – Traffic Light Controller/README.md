# Project 3 – Traffic Light Controller

## Objective

Design a digital controller to control traffic at an intersection of a busy main street (North-South) and an occasionally used side street (East-West).

- North South must be Green for a minimum of 25 seconds and will remain Green until traffic is present on East-West

- East West will remain Green for a maximum of 25 seconds

- Yellow lights on both streets must be for 4 seconds

## Source Files

- **Traffic Control Module** - Traffic_eng312_proj3.v
- **Traffic Control Test Bench A** - Traffic_Test_A_eng312_proj3.v	No traffic on either NS or EW- **Traffic Control Test Bench B** - Traffic_Test_B_eng312_proj3.v	Steady traffic on both NS and EW- **Traffic Control Test Bench C** - Traffic_Test_C_eng312_proj3.v	Steady traffic on NS, not EW- **Traffic Control Test Bench D** - Traffic_Test_D_eng312_proj3.v

	Steady traffic on EW, not NS
- **Traffic Control Test Bench E** - Traffic_Test_E_eng312_proj3.v

	Intermittent traffic on NS, none on EW
- **Traffic Control Test Bench F** - Traffic_Test_F_eng312_proj3.v	Intermittent traffic on EW, none on NS- **Traffic Control Test Bench G** - Traffic_Test_G_eng312_proj3.v	Intermittent traffic on both NS and EW, e.g. 1 car every 20 or 30 seconds.- **Traffic Control Test Bench H** - Traffic_Test_H_eng312_proj3.v

	Constant ongoing traffic detected on both NS and EW
