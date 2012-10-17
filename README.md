# MATLAB HS12 – Research Plan

> * Group Name: Schettino's Crew
> * Group participants names: Brechbuehler Raphael, Eugster Manuela, Reber Andreas, Schmid Fabian
> * Project Title: Modeling of a passenger ship evacuation 

## General Introduction

(States your motivation clearly: why is it important / interesting to solve this problem?)
(Add real-world examples, if any)
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)

The evacuation of a passenger liner due to fire, sinking or other issues leads to several problems. A large amount of passengers try to safe their lives and get to a rescue boat. Narrow and branched floors, smoke, inflowing water, the absence of illumination, rude passengers and so forth can make the evacuation difficult and reduce the number of survivors.

There are a lot of norms how to minimize the harm of such an evacuation. For example there are rules on the number of rescue boats dependent on the amount of passengers. With dry runs the staff is prepared for the case of emergency et cetera. Our approach is to model a passenger ship with a common geometrical outline and ground view. In an optimization process we will thereafter look for an ideal ground view, rescue boat distribution and their size to minimize the time needed for evacuation. 
Finally we will make a statement on possible improvements.

## The Model

We will base the modeling part on the work done by a group of former "MSSSM" students, by name Hans Hardmeier, Andrin Jenal , Beat Kueng and Felix Thaler. In their work "Modeling Situations of Evacuation in a Multi-level Building" they wrote a computer program in c with a MATLAB surface to rapidly simulate the evacuation of multi-level buildings. 

An implementation of a common ship shape will be necessary. We want to keep the following variables fix in order to be able to make strong conclusions.
Independent parameters:
- Number of passengers
- Overall capacity of the rescue boats
- Ship size and shape
- Area used by specific rooms (coaches for passengers, lounge area, corridors)

Our target is to decrease toe evacuation time. Measurements will be made on the time to evacuate ...
- 10%
- 50%
- 90%
- 100% 
... of all passengers.

To optimize, we change the following dependent variables:
- Disposition of the specific room types (eg. changing the geometry of the corridors without changing the total area used for corridors)
- Rescue boat size, number and position
- Control of the passenger flow by crew members (eg. is there staff to lead the passengers and how are they doing it?)

 
(Why is your model a good abstraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)


## Fundamental Questions

How much time can be saved by varying the dependent variables? 
- How much people can be saved by changing the disposition of the specific room types?
- Where are the bottlenecks during the evacuation? How can they be avoided?

What is the influence of the rescue boats?
- Are small or bigger boats better?
- Where do they have to be positioned?

In addition (if there is time left), we are interested in the difference between controlled and uncontrolled passenger flow to see the benefit of a controlling crew.
- Is the staff helping preventing chaos in evacuation scenarios?
- Whats the best way 

## Expected Results

We expect to see a big difference by changing the controlling variable.

(What are the answers to the above questions that you expect to find before starting your research?)


## References 


Helbling, Dirk - Molnar, Peter (1995): Social Force Model for Pedestrians Dynamics

SOLAS International Convention for the safety of life at sea 1974.

The "MSSSM" work "Modelling Situations of Evacuation in a Multi-level Building" by Hans Hardmeier, Andrin Jenal , Beat Kueng and Felix Thaler. Especially the code in c and MATLAB.

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)

## Research Methods

(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)


## Other

(mention datasets you are going to use)