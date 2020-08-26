## MATLAB Example: Catalytic Fixed Bed Reactor (FBR) Design

In the Reactor Design and Control Project (RDCP), a central point of the second year in my chemical engineering MEng course, groups of three students were tasked to design a reactor and a suitable control system for the production of phthalic anhydride (PA) via partial oxidation of o-xylene. 

The reactor design part of the project was agreed to be my responsibility, which is presented here as an example of my MATLAB skills, while my teammates focused on the development of the control structure in SIMULINK - the complete project report can be found [here](https://www.google.com/search?q=achieved&oq=achieved&aqs=chrome..69i57j0l7.1006j0j7&sourceid=chrome&ie=UTF-8)

The reactor design process was based on the development of a detailed MATLAB simulation of the suggested multi-tubular, fixed bed riser reactor which allowed evaluation of different reactor setups and their key performance metrics. Additionally, capabilities for sensitivity analysis of physical and technical parameters were included to assess both process stability/safety and potential process intensification opportunities.

A short summary of the technical specifics and some results can be found below.  

## Technical background:

A purified air stream containing o-xylene at low concentrations is forced into contact with a bed of fixed, spherical catalyst pellets (vanadium oxide) while passing through a thin, vertical tube ('riser reactor'). This results in a partial oxidation reaction R1, yielding the desired product PA - while simultanously, undesirable side reactions (complete and partial combustion R2/R3/R4/R5) occur. The energy release of the reaction is countered by circulation of a cooling medium, keeping the outer wall of the reactor tubes at constant temperature. 

<p align="center">
<a href="https://ibb.co/WGRDskf"><img src="https://i.ibb.co/rFXbvxH/rdcp.png" alt="rdcp" border="0"></a>
</p>

<p align="center">
 sketch of a riser reactor  |  the chemical reaction network |  differential control volume sketch 
</p>
  
By considering a differential control volume along the height of the cylindrical reactor and assuming radial homogenity, one can derive a suitable 1D model of the reactor. The 6 reacting species (xylene, PA, CO, CO2, O2 and water) and the energy balance yield seven coupled, non-linear ordinary differential equations. As reactant concentration is low, the pressure drop can be sufficiently described by a simple hydrostatic model, which can be decoupled. Specifying the reactor inlet stream conditions leaves an initial value problem in seven ODEs to be integrated numerically which yields a concentration and temperature profile of the reactor and allows calculation of several KPIs.

<p align="center">
<img src="https://imgbbb.com/images/2020/08/26/rdcp3.png" alt="rdcp3.png" border="0" />
</p>

<p align="center">
 concentration profiles  |  temperature profile |  KPI: PA-yield profile 
</p>

The optimal length in terms of PA-yield for the choosen diameter turns out to 2.72m, at which 4.9% of the theoretically possible amount of product has been formed; the low performance can primarily attributed to the parasitic side reactions which combust the formed product should it remain in the reactor for too long. The temperature profile shows a stark hot-spot temperature peak shortly after the inlet due to the given specification of wall temperature and inlet temperatue. Initially heat is transfered from the wall into the fluid, which accelerates the reaction and hence the energy release inside the reactor - a phenomenon which makes the ODE problem stiff and can cause the solver to break down undere certain permutations of conditions due to unphysically high temperature gradients.


<p align="center">
<img src="https://imgbbb.com/images/2020/08/26/rdcp47a66ee578c0e03c5.png" alt="rdcp47a66ee578c0e03c5.png" border="0" />
</p>

<p align="center">
 global PA yield  |  variance based sensitivity testing |  R1/R2 second order effects 
</p>


The low optimum yield inidicates a need for a recycle system and or improvements of the catalytic properties of the fixed bed pellets. Simulations of some advanced reactor configurations and implementation of a recycle system enabled achievement of a global PA-yield of 15%. Extensive OAT and variance based multivariate sensitivity analysis was conducted on the physical parameters of the catalyst and the reaction to give direction for future research efforts and assess influence of parameter uncertainty. For kinetic parameters a not unsual uncertainty of 5%, particulary in activation energy of R1 and R2, places PA yield in a possible range of 7.5-30% and warrants further experimental clarification of precision. Variance based sensitvity testing indicated that an improvement of catalytic properties would have the best pay off if a reduction of low temperature rate of R2 would be achievable.
