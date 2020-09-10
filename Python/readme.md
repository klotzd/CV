# Python Examples

These are some python projects completed over the COVID summer. Most are still being worked on and expanded whenever I have time, but already fulfill some of the basic functions initially intended.


## Example 1: BankDefaults - Tensorflow logistic regression implementation for classification of US bank defaults from FDIC call report data
<p align="center">
<a href="https://ibb.co/4sgfhwK"><img src="https://i.ibb.co/0BVXHpm/bankdefaults.png" alt="bankdefaults" border="0"></a>
</p>

<p align="center">
  equity to total assets vs log total assets  | net interest margin vs log total assets
</p>

Assignment project in "ML and RL for Finance", Coursera. Using FDIC call report data and macro economic outlook variables to predict historic US bank defaults. Using a (favourably, explained in notebook how) downsampled dataset the classifier achieves AUC 0.986 on 330 unseen test samples.

## Example 2: Football and the London Underground - Predicting the outcome of Football matches from tube traffic at nearby stations
<p align="center">
<a href="https://ibb.co/K6vYN03"><img src="https://i.ibb.co/tBrSZmW/confusion-matrix.png" alt="confusion-matrix" border="0"></a>
</p>  
<p align="center">
  receiver operating characteristics curve | confusion matrix
</p>

Can the outcome of a london club's home match be inferred from the entry/exit counts at the closest underground station?
Yes, it can. With about 70% accuracy (AUC ~ 0.75) using a neural network with one hidden layer.

Additionally using a custom signal classification kernel and b-spline regressions tricks, this can be boosted to 0.75% accuracy on a MLP (AUC 0.8) and RF classifier:

<p align="center">
<a href="https://ibb.co/P58dwxC"><img src="https://i.ibb.co/nDSFzrk/kernels.png" alt="kernels" border="0"></a>
</p>

<p align="center">
  boxplot of kernel results | signals b-spline derivatives | kernel components
</p>

## Example 3: MolecularDynamics - Time oriented, hard disc 2D molecular dynamics simulation of ideal gases

Simple implementation of a time-oriented simulation of non-interacting hard disks - a (two-dimensional) ideal gas. Simulated pressure (1000 particles) within 2% of ideal gas law prediction. Various initalisation functions (random, maxwellian, gaussian) and built in animation and analysis functions. Currently working on enabling reactive multi-species mixtures to simulate the fundamental kinetic reaction orders from first principles.
p align="center">
  <img src="https://github.com/klotzd/CV/blob/master/Python/img/boltzmannconvergence_gif.gif" width="256" title="Github Logo">
</p>




<p align="center">
  
![alt text](https://github.com/klotzd/CV/blob/master/Python/img/boltzmannconvergence_gif.gif)

</p>
<p align="center">
  convergence towards maxwell-boltzmann distribution of gas initialised with random uniform $v_x, v_y$
</p>

## Example 4: WineAnalysis - Webscraping and analysi of ~2M wines with reviews, tasting notes and food pairings

Scraped approx 2 million wine entries from the wine review app vivino. Analysis and data visualisation of review ratings, popularity, tasting notes and suggested food pairings. Start of larger project intending to combine the primary wine information with geological and weather data to predict wine quality of future harvests. 
