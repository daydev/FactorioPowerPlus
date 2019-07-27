A new take on the idea of a power meter. 
This one is unique in that it measures power utilization, i.e. how hard your power generators are working, or in other words how close are you to being in trouble. 

Outputs three signals: percentage of power production utilization broken down by the three priorities: primary, secondary and tertiary. 
Primary production is solar panels (also wind turbines in mods). 
Secondary production is steam engines and steam turbines (and various similar things in mods). 
Tertiary production is accumulators. 

As an example, suppose you have ten solar panels (60 kW each) and 1 steam engine (900 kW), and your factory consumes 690 kW of power. 
In this case the power meter combinator would output "primary" = 100 (solar panels are fully utilized to give 600 kW), 
and "secondary" = 10 (the lone steam engine is utilized for 10% to provide the remaining 90 kW). 
In this case "tertiary" signal would be zero, because there are no accumulators. 

Currently the signals that the meter combinator outputs are hardcoded (see their icons in the thumbnail), but they are custom signals, so they shouldn't conflict with anything. 

The meter should be able to function with any modded power source, unless a mod does something really crazy. 

The mod should also be UPS friendly, as the meter uses local hax to make the measurements, not global scans, so every meter updates in (small) constant time.
Be warned, though, due to the nature of the hax it uses, the meter actually provides a small amount of free power (up to 18 kW at the extreme, usually a few kW), 
and if you try to replace your solar fields with power meters, then you probably **will** run into UPS issues.   

If instead of or in addition to power utilization you want to measure power production broken down by generator type 
or raw power production/consumption numbers I direct you to 
[Circuit Power Measurement Combinator](https://mods.factorio.com/mod/Circuit_Power_Measurement_Combinator) 
and [Factor-I/O](https://mods.factorio.com/mod/FactorIO)