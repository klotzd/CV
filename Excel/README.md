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
    * policy assumptions of current scenario 
    * technological assumptions at year **t**
    * financing assumptions at year **t**
2. Combine individual KPIs and current ratio of the maximum theoretically usable capacity into a logistically scaled 'investment attractiveness'
3. Calculate the total investment potential of year **t+1** by adding ordinary decomissioning, closure of loss-making plants and projected demand growth
4. Allocate **t+1** investment potential according to 'investment attractiveness' and update plant stock
5. Calculate GHG emissions for year **t+1**
6. Repeat

## One Example Scenario: Carbon Tax and Carbon Capture and Storage Subsidies via Tax Credits

<p align="center">
<a href="https://ibb.co/vDRgbLD"><img src="https://i.ibb.co/V35rdM3/tcredit.png" alt="tcredit" border="0"></a>
</p>

This scenario considered the implementation of tax credits to CCS technology installed on new natural gas power plants, in addition to an annually increasing (2.5%p.a.) carbon tax of $25/tCO2.  Current CCS technology is not economically viable. The addition of a CCS unit increases the LCOE of a natural gas plant by $30.54/MWh.  Hence, in business as usual, no natural gas power plants with CCS are built over the next 30 years. 

Therefore, to introduce natural gas plants with CCS into the power generation mix, pre-existing carbon taxes and tax credits will be implemented to achieve further decarbonisation. Installing CCS technology on coal plants was not considered, as natural gas research from Portland State University found that eliminating coal as an energy source is the most significant step for the USA to fulfil GHG emissions targets under the Paris Climate Agreement. Tax incentives to reduce CO2 emissions considered in this model is based on the FUTURE Act and Carbon Capture Act that has been extended and expanded section 45Q of US tax code. Section 45Q of the US tax code provides a tax credit to industrial scale power plants that use CCS technology to store the CO2 geologically or utilise it as afeedstock of products, such as manufacture of plastics. 

Accordingly,  a  carbon  tax  credit  of  $35/tCO2  was imposed on utility scale natural gas power plants in this model.Addition of tax credits lowers the LCOE from $65.95/MWh to $53.23/MWh whilst, ROI in 30 years has increased to 81.90% when compared to 48.93% in business as usual. As solar and onshore wind start to reach their maximum feasible generation shares, the investment attractiveness of the next lowest LCOE technology, natural gas with CCS, starts to become more appealing. Therefore, in 2031, natural gas plus CCS power generation plants start to increase, with a rapid increase from 2040 as solar and onshore wind near their maximum feasible capacities.

Carbon emissions have decreased by 1156 MtCO2 between 2020 and 2050. A decarbonisation of a 69% reduction in carbon emissions is attained with a constant decline in total carbon emissions over the 30 years despite growing  demand for  electricity. Onshore wind is the most abundant energy source, comprising 28% of the energy mix in contrast to offshore wind that is economically unfavourable due to its high capital costs.  Despite the heavy reliance of the energy mix on wind, issues of wind intermittency limits would be alleviated by the 42% combined share of natural gas and natural gasw ith CCS as a peak demand hour energy source.
