# MATLAB HS12 – Research Plan

> * Group Name: Schettino's Crew
> * Group participants names: Brechbuehler Raphael, Eugster Manuela, Reber Andreas, Schmid Fabian
> * Project Title: Modeling of a passenger ship evacuation 

## General Introduction

The evacuation of a passenger liner due to fire, sinking or other issues leads to several problems. A large amount of passengers try to safe their lives and get to a rescue boat. Narrow and branched floors, smoke, inflowing water, the absence of illumination, rude passengers and so forth can make the evacuation difficult and reduce the number of survivors.

There are a lot of norms how to minimize the harm of such an evacuation. For example there are rules on the number of rescue boats dependent on the amount of passengers [2]. With dry runs the staff is prepared for the case of emergency et cetera. 
In real life ship corridor reproduction, the behavior of distressed people is studied.

Another approach is to model such ship evacuations numerically on the computer. As an example the software maritimeEXODUS by a development team from the University of Greenwich is a  PC based evacuation and pedestrian dynamics model that is capable of simulating individual people, behaviour and vessel details. The model includes aspects of people-people, people-structure and people-environment interaction. It is capable of simulating thousands of people in very large ship geometries and can incorporate interaction with fire hazard data such as smoke, heat and toxic gases and angle of heel.” [5]

Our approach is similarly to model a passenger ship with a common geometrical outline and ground view. In an optimization process we will thereafter look for an ideal ground view, rescue boat distribution and their size to minimize the time needed for evacuation. 
Finally we will make a statement on possible improvements.

## The Model

We will base the modeling part on the work done by a group of former "MSSSM" students, by name Hans Hardmeier, Andrin Jenal , Beat Kueng and Felix Thaler [3]. In their work "Modeling Situations of Evacuation in a Multi-level Building" they wrote a computer program in c with a MATLAB surface to rapidly simulate the evacuation of multi-level buildings. 

An implementation of a common ship shape will be necessary. We want to keep the following variables fix in order to be able to make strong conclusions.
Independent parameters:
- Number of passengers
- Overall capacity of the rescue boats
- Ship size and shape
- Area used by specific rooms (coaches for passengers, lounge area, corridors)

Our target is to decrease the evacuation time. Measurements will be made on the time to evacuate ...
- 10%
- 50%
- 90%
- 100% 
... of all passengers.

To optimize, we change the following dependent variables:
- Disposition of the specific room types (e.g. changing the geometry of the corridors without changing the total area used for corridors)
- Rescue boat size, number and position
- Control of the passenger flow by crew members (e.g. is there staff to lead the passengers and how are they doing it?)
 
Is our model a good abstraction of the real situation? 
There are many parameters we do not model in our simulation. E.g. fire and smoke, the tilt of the ship or handicapped passengers are disregarded. By leaving out this details we get a very simplified model. However, by starting the optimization process by data of a nowadays passenger liner [6] we hope to see some real evacuation dynamics in this system and therefore make conclusion on the fundamental questions discussed in the next section.

## Fundamental Questions

How much time can be saved by varying the dependent variables? 
- How much people can be saved by changing the disposition of the specific room types?
- Where are the bottlenecks during the evacuation? How can they be avoided?

What is the influence of the rescue boats?
- Are small or bigger boats better?
- Where do they have to be positioned?

In addition (if there is time left), we are interested in the difference between controlled and uncontrolled passenger flow to see the benefit of a controlling crew.
- Is the staff helping preventing chaos in evacuation scenarios?
- What is the best way to lead the passengers out of the ship?

## Expected Results

-Even though modern ships are quite optimized in regard to evacuation time, they are always a compromise between safety and luxury.
 Therefore we are convinced to find a superior adjustment of the decks geometries to increase the survival rate.

-Since the rescue boats can not be averaged but are rather concentrated over one or two decks, we consider the staircases as the bottlenecks.

-In alinging this variables we are persuaded of a reduction of the overall evacuation time.

-We suppose that smaller and evenly spread rescue boats combined with a higher quantity will scale the evacuation time down. Certainly there is
 going to be an optimum in size which we are willing to find.

-By controlling the rescue we assume to detect a huge decrease in evacuation time. Further we have the hypothesis that disorder can be minimized. 
 The crew who is familiar with the decks and the emergency exits is able to guide the passengers in minimum time to the rescue boats.


## References 

[1] Helbling, Dirk - Molnar, Peter (1995): Social Force Model for Pedestrians Dynamics

[2] SOLAS International Convention for the safety of life at sea 1974. Especially Chapter 3: Life-saving appliances and arrangements.

[3] The "MSSSM" work "Modelling Situations of Evacuation in a Multi-level Building" by Hans Hardmeier, Andrin Jenal , Beat Kueng and Felix Thaler. Especially their code in c and MATLAB which we are going to use.

[4] http://www.shipevacuation.com/new-ship-evacuation-procedures.html

[5] maritimeEXODUS 

[6] http://www.cruisedeckplans.com. Floor plans of common passenger ships

[7] http://travel.travelocity.com/ecruise/ShipDetailsDeck.do?shipId=227&deckId=Deck%2014. Floor plan of the Costa Concordia.

## Research Methods

Since the work process is still in its initial state it is very difficult to determine the exact research methods. 
Certainly our coding is going to be based on the work mentioned above.[3]
Considering everything else we decided to continuously update this part of the research plan during the work progress.

## Other

There are very detailed floor plans of common passenger ships available on the webpages [6] and [7]. It will be a good source to make further abstractions to get graphical data for our simulation program.