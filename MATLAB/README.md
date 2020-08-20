## MATLAB Example: Catalytic Fixed Bed Reactor (FBR) Design

In the Reactor Design and Control Project (RDCP), a central point of the second year in my chemical engineering MEng course, groups of three students were tasked to design a reactor and a suitable control system for the production of phthalic anhydride (PA) via partial oxidation of o-xylene. 

The reactor design part of the project was agreed to be my responsibility, which is presented here as an example of my MATLAB skills, while my teammates focused on the development of the control structure in SIMULINK - the complete project report can be found [here](https://www.google.com/search?q=achieved&oq=achieved&aqs=chrome..69i57j0l7.1006j0j7&sourceid=chrome&ie=UTF-8)

The reactor design process was based on the development of a detailed MATLAB simulation of the suggested multi-tubular, fixed bed riser reactor which allowed evaluation of different reactor setups and their key performance metrics. Additionally, capabilities for sensitivity analysis of physical and technical parameters were included to assess both process stability/safety and potential process intensification opportunities.

A short summary of the technical specifics and some results can be found below.  

## Technical background:

A purified air stream containing o-xylene at low concentrations is forced into contact with a bed of fixed, spherical catalyst pellets (vanadium oxide) while passing through a thin, vertical tube ('riser reactor'). This results in a partial oxidation reaction R1, yielding the desired product PA - while simultanously, undesirable side reactions (complete and partial combustion R2/R3/R4/R5) occur. The energy release of the reaction is countered by circulation of a cooling medium, keeping the outer wall of the reactor tubes at constant temperature. 

-><a href="https://ibb.co/WGRDskf"><img src="https://i.ibb.co/rFXbvxH/rdcp.png" alt="rdcp" border="0"></a><-

->_Sketch of a riser reactor_ | _the chemical reaction network_ | _differential control volume sketch_<-

By considering a differential control volume along the height of the cylindrical reactor and assuming radial homogenity, one can derive a suitable 1D model of the reactor. The 6 reacting species (xylene, PA, CO, CO2, O2 and water) and the energy balance yield seven coupled, non-linear ordinary differential equations. As reactant concentration is low, the pressure drop can be sufficiently described by a simple hydrostatic model, which can be decoupled. Specifying the reactor inlet stream conditions leaves an initial value problem in seven ODEs to be integrated numerically.

<img src="https://render.githubusercontent.com/render/math?math=\frac{d\dot{n}_{xyl}}{dh}= -A(1-\epsilon)\rho_c (r_1+r_2+r_3); r_i=\frac{k_i c_{O_2}^{n_i }b_ic_{xyl} \mathrm{and} k_i=e^{\mathrm{ln}k_{0,i}-\frac{E_{a,i}}{RT}}}{1+b_ic_{xyl}}">

