## MATLAB Example: Catalytic Fixed Bed Reactor (FBR) Design

In the Reactor Design and Control Project (RDCP), a central point of the second year in my chemical engineering MEng course, groups of three students were tasked to design a reactor and a suitable control system for the production of phthalic anhydride (PA) via partial oxidation of o-xylene. 

The reactor design part of the project was agreed to be my responsibility, which is presented here as an example of my MATLAB skills, while my teammates focused on the development of the control structure in SIMULINK - the complete project report can be found [here](https://www.google.com/search?q=achieved&oq=achieved&aqs=chrome..69i57j0l7.1006j0j7&sourceid=chrome&ie=UTF-8)

The reactor design process was based on the development of a detailed MATLAB simulation of the suggested multi-tubular, fixed bed riser reactor which allowed evaluation of different reactor setups and their key performance metrics. Additionally, capabilities for sensitivity analysis of physical and technical parameters were included to assess both process stability/safety and potential process intensification opportunities.

A short description of the technical specifics and a description of the implementation and the results can be found below.  

## Quick summary of the technical background:

A purified air stream containing o-xylene at low concentrations is forced into contact with a bed of fixed, spherical catalyst pellets (vanadium oxide) while passing through a thin, vertical tube ('riser reactor'). This results in a partial oxidation reaction R1, yielding the desired product PA - while simultanously, undesirable side reactions (complete and partial combustion R2/R3/R4/R5) occur. The energy release of the reaction is countered by circulation of a cooling medium, keeping the outer wall of the reactor tubes at constant temperature. 

<a href="https://ibb.co/Y4CVsfr"><img src="https://i.ibb.co/gb2cKtn/rdcp.png" alt="rdcp" border="0">

The reactor can be completely described by a set of differential equations: six mass balances, and energy balance and a pressure drop equation. The applied hydrostatic pressure drop equation can be decoupled and hence does not require a numerical approach, leaving a final set of seven coupled, non-linear ordinary differential equations to be integrated numerically.

An exemplary mass balance is shown below to highlight the highly non-linear  character of the resulting set of equations:

$$ \frac{d\dot{n}_{xyl}}{dh}= -A(1-\epsilon)\rho_c (r_1+r_2+r_3)$$

where the chemical rates of reaction $r_i$ are given by classic-surface reaction type terms of the form

$$ r_i=\frac{k_i c_{O_2}^{n_i }b_ic_{xyl}}{1+b_ic_{xyl}} $$

for experimentally determined values of $b_i$ and $n_i$, as well as $k_i$'s given by arrhenius expressions:

$$ k_i=e^{\mathrm{ln}k_{0,i}-\frac{E_{a,i}}{RT}} $$
