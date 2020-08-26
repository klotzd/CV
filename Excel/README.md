# Excel Example: Modelling the Evolution of the US Electricity Generation Mix until 2050 

This work was part of the techno-economic project in year three of my Chemical Engineering Course. Our task as a group of 9 students was to create a techno-economic analysis and a  consulting-style strategy paper recommending and evaluating different policy scenarios to achieve a 'realistic' level of decarbonisation of an inudstry segment of our choice: we opted for the decarbonisation of US electricity generation.

While every single one of my team members was a fantastic co-worker and contributed outstanding work to the overall project, Janusshan Sivanesakanthan and I took responsbility of creating the model simulating the effects of the various policy scenarios. The resulting file is something we're quite proud of and good testament to our proficiency in excel and effective teamwork - it also shows the sheer variability and power of microsoft excel and why it's still preferable to a pure programming approach in some applications.

## The background

The goal of the model was to develop a tool that allows to make quantitative predictions about the us electricity generation mix under different carbon tax / tax credit scenarios. The US is one of the most market oriented economies in the world, and hence any model would have to use a paradigm of profit based investment allocation and have no direct governmental intervention in form of nationalised enterprises. It needed to combine current EIA data, micro economic analysis of technological projects and macro economic considerations: 

<p align="center">
<img src="https://imgbbb.com/images/2020/08/26/tep1.png" alt="tep1.png" border="0" width="745" height="400"/>
</p>

<p align="center">
       schematic outline of the model
</p>

The iterative procedure calculated for a year **t** can be summarised as
1. Calculate KPIs (LCOE, ROI, etc) for average investment project of each electricity source subject to  
  * policy assumptions of scenario 
  * technological assumptions at year **t**
  * financing assumptions at year **t**
2. Combine individual KPIs and current ratio of the maximum theoretically usable capacity into a logistically scaled 'investment attractiveness'
3. Calculate the total investment potential of year **t+1** by adding ordinary decomissioning, closure of loss-making plants and projected demand growth
4. Allocate **t+1** investment potential according to 'investment attractiveness' and update plant stock
5. Calculate GHG emissions for year **t+1**
6. Repeat
