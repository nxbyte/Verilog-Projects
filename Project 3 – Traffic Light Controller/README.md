# Project 3 – Traffic Light Controller

## Objective

Design a digital controller to control traffic at an intersection of a busy main street (North-South) and an occasionally used side street (East-West).

- North South must be Green for a minimum of 25 seconds and will remain Green until traffic is present on East-West

- East West will remain Green for a maximum of 25 seconds

- Yellow lights on both streets must be for 4 seconds

This project includes a presentation detailing the thought process and application of this implementation of a traffic light controller. [[PDF] Project 3 Presentation](/Project%203%20–%20Traffic%20Light%20Controller/Project%203%20Presentation.pdf)

## Waveforms

Simulation results from test A of the Traffic Light Controller module **(No traffic on either NS or EW)**

![Project 3 Waveform for Test A](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_A.png)


Simulation results from test B of the Traffic Light Controller module **(Steady traffic on both NS and EW)**

![Project 3 Waveform for Test B](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_B.png)


Simulation results from test C of the Traffic Light Controller module **(Steady traffic on NS, not EW)**

![Project 3 Waveform for Test C](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_C.png)


Simulation results from test D of the Traffic Light Controller module **(Steady traffic on EW, not NS)**

![Project 3 Waveform for Test D](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_D.png)


Simulation results from test E of the Traffic Light Controller module **(Intermittent traffic on NS, none on EW)**

![Project 3 Waveform for Test E](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_E.png)


Simulation results from test F of the Traffic Light Controller module **(Intermittent traffic on EW, none on NS)**

![Project 3 Waveform for Test F](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_F.png)


Simulation results from test G of the Traffic Light Controller module **(Intermittent traffic on both NS and EW, e.g. 1 car every 20 or 30 seconds)**

![Project 3 Waveform for Test G](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_G.png)


Simulation results from test H of the Traffic Light Controller module **(Constant ongoing traffic detected on both NS and EW)**

![Project 3 Waveform for Test H](/Project%203%20–%20Traffic%20Light%20Controller/Simulation%20Waveforms/project3_test_H.png)

## Source Files

- **Traffic Control Module** - Traffic_eng312_proj3.v
- **Traffic Control Test Bench A** - Traffic_Test_A_eng312_proj3.v- **Traffic Control Test Bench B** - Traffic_Test_B_eng312_proj3.v- **Traffic Control Test Bench C** - Traffic_Test_C_eng312_proj3.v	- **Traffic Control Test Bench D** - Traffic_Test_D_eng312_proj3.v
- **Traffic Control Test Bench E** - Traffic_Test_E_eng312_proj3.v
- **Traffic Control Test Bench F** - Traffic_Test_F_eng312_proj3.v- **Traffic Control Test Bench G** - Traffic_Test_G_eng312_proj3.v- **Traffic Control Test Bench H** - Traffic_Test_H_eng312_proj3.v
