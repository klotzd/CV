%% RDCP - Reactor Design Code - GROUP 9
%--------------------------------------------------------------------------
%   For list of used nomenclature, see end of code

%% S1 - clean start
close all
clc

%% S2 - user input
%  Collects user input on sensitivity testing and stores 
%  for further processing

%--------------- Choose sensitivity testing or normal simulation ----------

simulationmode=questdlg('would you like to run OAT sensitivity testing?','title','Yes',...
                        'No','No');                 
switch simulationmode
    case 'Yes'
            sensitivitytest = 1;                
    case 'No'
            sensitivitytest = 0;
end

%--------------- Determining parameters of sensitivity testing ------------

if sensitivitytest == 1
    
        choices=zeros(5,1);
      
        answer=questdlg('Would you like to test reaction parameters or design parameters?','title',...
                        'Design parameters','Reaction Parameters','Design parameters');
         
                    switch answer
                        case 'Design parameters'
                                choices(1)=1;
                        case 'Reaction parameters'
                                choices(1)=0;
                    end 
                    
    if choices(1) == 1
                    
             designparameter={'feedmassflux','feed mole fraction xylene' 'feed temperature', 'feed pressure' 'column diameter', 'voidage',...
                              'catalyst density','heat transfer coefficient','wall temperature'};
             [answer,~]=listdlg('PromptString','choose which parameter you want to vary:','SelectionMode','single',...
                                       'ListString',designparameter,'ListSize',[200,80]);
             
             choices(2) = answer;
             testingof{1,1}=designparameter{1,answer};
             
    else 
             choices(2) = 0;
             
             reactionparameter={'preexponential factors','activation energies','rate law parameters','reaction enthalpies'};
             [answer,~]=listdlg('PromptString','choose which parameter you want to vary:','SelectionMode','single',...
                                       'ListString',reactionparameter,'ListSize',[200,80]);
             choices(3) = answer;
             testingof{1,1}=reactionparameter{1,answer};
             
             if choices(3) == 3
             
                 parameter={'n - power of oxygen','b1 - partial oxidation of xylene','b2 - oxidation of xylene','b3 - oxidation of phtalic anhydride'};
                [answer,~]=listdlg('PromptString','Which of the rate law parameters do you want to vary?','SelectionMode','single',...
                                       'ListString',parameter,'ListSize',[280,80]);
                                   
                 choices(4) = answer;
                 testingof{1,2}=parameter{1,answer};
             else
                 
                reaction={'Xylene -> Phtalic Anhydride','Xylene -> Carbon Monoxide','Xylene -> Carbon Dioxide','Phtalic Anhydride -> Carbon Monoxide','Phtalic Anhydride -> Carbon Dioxide'};
                [answer,~]=listdlg('PromptString','For which reaction do you want to vary the choosen parameter?','SelectionMode','single',...
                                       'ListString',reaction,'ListSize',[280,80]); 
             
                choices(4) = answer;
                testingof{1,2}=reaction{1,answer};
             end
    end
    
%--------------- Determining variation range of sensitivity testing -------

            varrange=inputdlg('Enter the variation range in percent:','title',[5 95],{'10'});
            testingof{1,3}=num2str(varrange{1,1});
            
            varrange=str2double(varrange{1,1})/100;
            choices(5)=varrange;
            
            % create string for generation of result plots
            if choices(1)== 1
            testingof(:,2)=[];
            test=strjoin(testingof,{' sensitivty testing; variationrange in %: ±'});
            else
            test=strjoin(testingof,{': ',' sensitivty testing; variationrange in %: ±'});
            test=strsplit(test,';');
            end
            clear varrange answer reaction parameter reactionparameter designparameter testingof simulationmode 
            % tidy up workspace
%--------------------------------------------------------------------------
end

tic

%% S3 - definitions of given parameters and setup of initial conditions

%------ define given parameters as global variables -----------------------

global designparameters preexponentialfactors activationenergies ...
       ratelawparameters enthalpyparameters heatcapacity ICs ndotNITIC

designparameters=([2300 0.01 600 1.3 0.03 0.5 1300 0.096 610]);
% feedmassflux [kg/hrm²], feed mole fraction xylene, feed temp. [K], 
% feed pressure [bar], diameter [m], voidage, catalyst density [kg/m³], 
% heat transfer coeff. [kW/m²K], column wall temp. [K]

preexponentialfactors=([19.24 20.04 20.36 28.55 28.45]);
% natural logarithm of pre exponential factors [-]

activationenergies=([14987 15862 15862 16040 16040]);
% activation energies divided by universal gas constant [K]

ratelawparameters=([429 2024 1.0001 0.4280 0]);
% specific rate law parameters

enthalpyparameters=([-128300 -1526200 -3273600 -265600 -139800]);
% enthalpies of reactions [kJ/kmol]

heatcapacity=([0 -1.025*10^-10 2.881*10^-7 -5*10^-5 1.0310]);
% coefficients of third order polynomial cp correlation of air

%------ calculate initial conditions from design parameters ---------------

% calculating molar feed flow - taking air as 79 % N2, 21 % O2:
% AVG molar weight of feed: 29.6321 kg/kmol

AVGMW=29.6321;                                                      %[kmol/kg]
molarfeedflow=designparameters(1)*designparameters(5)^2*pi/4/AVGMW; %[kmol/hr]

ICs=([0 0 0 molarfeedflow*(1-designparameters(2))*0.21 molarfeedflow*designparameters(2) 0 designparameters(3) designparameters(4)*10^5]);
% Initial Conditions:
% intial CDX - CMX - WAT - OXY (function of feed XYL conc) - XYL - PAE / [kmol/hr] - T [K] - p [Pa]

ndotNITIC=molarfeedflow*(1-designparameters(2))*0.79;  % flowrate of nitrogen - inert [kmol/hr]

%% S4 - simulating fixed bed reactor

func=@fixedbed;                 %   define function as output of fixedbed function
h=([0 15]);                     %   define height range over which to integrate


%------ normal simulation of FBR ------------------------------------------ 

    if sensitivitytest == 0                 % no sensitivity testing, original parameters and ICs
        
        options=odeset('MaxStep',0.01);     % specify maximum integration stepsize as 1 cm
        
        [h, results]=ode15s(func,h,ICs,options); % integrate system using ode15s to obtain raw data 
        plotresults=dataanalysis(results,ICs);   % extract and calculate relevant data using dataanalysis function
        createplots(plotresults,h)               % create relevant plots from generated data set 
        
        economicresults=economicanalysis(results,h,sensitivitytest);    % evaluate recycle implementation
        
%------ sensitivity analysis on FBR ---------------------------------------
        
    elseif sensitivitytest == 1             % apply sensitvity testing with the earlier specified variation 
        
        h=linspace(0,15,1500);              % for sensitivity testing, force a stepsize of 1cm for uniform data size
        sensitivityresults=zeros(1500,30);      % create matrix for sensitvity data storage
        
        for i=1:5                           % loop over individual variations
                sensitivitysetup(choices,i) % generate parameter variation using sensitivitysetup function 
                
                [h, results]=ode15s(func,h,ICs);        % integrate system using i-th iteration of varied parameters
                plotresults=dataanalysis(results,ICs);  % extract and calculate relevant data using dataanalysis function 
                economicresults=economicanalysis(results,h,sensitivitytest);    % also calculate global yields
                
                sensitivityresults(:,6*i-5)=plotresults(:,1); % store conversion, yield, PAE selectivity, CO/CO2 ratio and 
                sensitivityresults(:,6*i-4)=plotresults(:,2); % temperature,global yield data of each variation in single matrix
                sensitivityresults(:,6*i-3)=plotresults(:,10);
                sensitivityresults(:,6*i-2)=plotresults(:,12);
                sensitivityresults(:,6*i-1)=plotresults(:,13);
                sensitivityresults(:,6*i)=economicresults(:,1);
        end
        
        sensitivityplots(sensitivityresults,choices,test,h)   % create relevant plots using sensitivityplot function
    
    end

    toc
    
%% S6 - functions

function ODEs=fixedbed(~,Balance)

% this function creates the system which is to be integrated by the 
% built in ODE solver. 

% defining physical constants
g=9.81;                 % gravitational acceleration [m/s²]
R=8314.46;              % universal gas constant [J/kmolT]

% import pre defined parameters and assign derived quantities

global designparameters enthalpyparameters ndotNITIC heatcapacity ratelawparameters...
       preexponentialfactors activationenergies

columnarea=designparameters(5)^2*pi/4;         % [m²]
columnperimeter=designparameters(5)*pi;        % [m]
feedmassflux=designparameters(1);              % [kg/m²hr]
voidage=designparameters(6);                   % [-]
catdens=designparameters(7);                   % catalyst density [kg/m³]

% evaluate 'active area' - effective mass of catalyst p. unit length
AA=columnarea*(1-voidage)*catdens;                 % [m]

% define the system of balances / unknowns 
ndotCDX=Balance(1);
ndotCMX=Balance(2);
ndotWAT=Balance(3);
ndotOXY=Balance(4);
ndotXYL=Balance(5);
ndotPAE=Balance(6);
T=Balance(7);
p=Balance(8);

% define the heat capacity function
cp=heatcapacity(2)*T^3+heatcapacity(3)*T^2+...
    heatcapacity(4)*T+heatcapacity(5);
                                            
% define the arrhenius equations
k=zeros(1,5);
for i=1:5
        k(i)=exp(preexponentialfactors(i)-activationenergies(i)./T);
end

% evaluate relevant concentrations
molarflow=sum(Balance(1:6,1))+ndotNITIC; % [kmol/hr]
volumeflow=molarflow*R*T./p;             % [m³/hr]

cOXY=ndotOXY./volumeflow;                % concentrations [kmol/m³]
cPAE=ndotPAE./volumeflow;
cXYL=ndotXYL./volumeflow;

% define reaction rates
r(1)=(k(1)*cOXY^ratelawparameters(4)*ratelawparameters(1)*cXYL)./(1+ratelawparameters(1)*cXYL);
r(2)=(k(2)*cOXY^ratelawparameters(4)*ratelawparameters(2)*cXYL)./(1+ratelawparameters(2)*cXYL);
r(3)=(k(3)*cOXY^ratelawparameters(4)*ratelawparameters(2)*cXYL)./(1+ratelawparameters(2)*cXYL);
r(4)=k(4)*cOXY^ratelawparameters(4)*ratelawparameters(3)*cPAE;
r(5)=k(5)*cOXY^ratelawparameters(4)*ratelawparameters(3)*cPAE;

% define reaction heat generation rates
dQreact=zeros(1,5);
for i=1:5
    dQreact(i)=AA*r(i)*enthalpyparameters(i);
end

dQreaction=sum(dQreact);            % sum of heat generated by reaction [kJ/hr]

% define convective heat exchange rate
dQconvection=columnperimeter*designparameters(8)*(T-designparameters(9))*3600; % [kJ/hr]

% total convective and reactive energy change
dH=-dQreaction-dQconvection;        % [kJ/hr]

% defining ODE's describing the system:

dnCDXdz=8*AA*(r(3)+r(5));
dnCMXdz=8*AA*(r(2)+r(4));
dnWATdz=AA*(3*r(1)+5*r(2)+5*r(3)+2*r(4)+2*r(5));
dnOXYdz=-AA*(3*r(1)+6.5*r(2)+10.5*r(3)+3.5*r(4)+7.5*r(5));
dnXYLdz=-AA*(r(1)+r(2)+r(3));
dnPAEdz=AA*(r(1)-r(4)-r(5));
dTdz=dH/(feedmassflux*columnarea*(1-voidage)*cp);
dpdz=-catdens*(1-voidage)*g;
ODEs=([dnCDXdz; dnCMXdz; dnWATdz; dnOXYdz; dnXYLdz; dnPAEdz; dTdz; dpdz;]);

% outputting vector of differential equations to be integrated
end

%--------------------------------------------------------------------------
% functions for data analysis

function [plotresults]=dataanalysis(results,ICs)

% this function takes in the raw data obtained by the ODE solver and 
% processes, extracts and reformats the data.

global ndotNITIC                % import inert flowrate

% calculate yield
maxyield=ICs(5);                    % max. theoretical yield at full conv. of XYL to PAE
yieldPAE=results(:,6)/maxyield*100; % actual yield - relation of PAE formed to max yield

% calculate o-xylene conversion
convXYL=(ICs(5)-results(:,5))./ICs(5)*100; % amount XYL reacted to amount of XYL fed

% calculate PAE selectivity 
selectivityPAE=results(:,6)./(ICs(5)-results(:,5)); % amount PAE formed to amount of XYL reacted

% calculate mole fractions of individual components:
xCOMP=zeros(size(results,1),7);
ntotal=zeros(size(results,1),1);
    for i=1:size(results)
    ntotal(i,1)=sum(results(i,1:6))+ndotNITIC;           % total molar flowrate 
    xCOMP(i,1)=results(i,1)/ntotal(i);                   % flowrate of X to total flowrate
    xCOMP(i,2)=results(i,2)/ntotal(i);                   % -> mole fraction [-]
    xCOMP(i,3)=results(i,3)/ntotal(i);
    xCOMP(i,4)=results(i,4)/ntotal(i);
    xCOMP(i,5)=results(i,5)/ntotal(i);
    xCOMP(i,6)=results(i,6)/ntotal(i);
    xCOMP(i,7)=ndotNITIC/ntotal(i);
    end

% calculate CO selectivity
selectivityCO=results(:,2)./(ICs(5)-results(:,5));  % CO formed to XYL reacted

% CO/CO2 ratio
CMXtoCDX=results(:,2)./results(:,1);                % CO formed to CO2 formed

% extract pressure
pressure=results(:,8)/10^5;                         % pressure [bar]

% extract temperature
temperature=results(:,7);                           % temperature [K]

plotresults=([yieldPAE convXYL xCOMP selectivityPAE...
              selectivityCO CMXtoCDX temperature pressure]); 
          
% output matrix of processed data
end

function [economicresults]=economicanalysis(results,h,sensitivitytest)

global ICs designparameters

if sensitivitytest == 0                     % execute standard analysis
    
    % calculating global yield for different o-xylene recovery rates

    alpha=([0.9 0.95 0.99]);                % define array of downstream XYL recovery rates
    [n, ~]=size(results);                   % create matrices for data storage
    feedwrecycleXYL=zeros(n,3);
    globalyield=zeros(n,3);
    
        for i=1:3
            feedwrecycleXYL(:,i)=(ICs(5)-results(:,5)*alpha(i));         % calculate feedrate required for recycle with recovery rate i
            globalyield(:,i)=(results(:,6))./feedwrecycleXYL(:,i)*100;   % global yield: ratio PAE produced / XYL fed
        end
    [opt, pos]=max(globalyield);                             % find maximum and position for each recovery rate
    globalyieldoptima=([transpose(opt) h(pos)]);
    globalyieldoptima=round(globalyieldoptima,2);

    % calculate potential heat recovery rates
    numint=(h(2,1)-h(1,1))*cumtrapz((results(:,7)-designparameters(9)));        % numeric integration of the temperature gradient
    heatrecovery(:,1)=designparameters(5)*pi*designparameters(8)*numint*3600;   % calculate cumulative heat recovery potential up to height h

    % extract heat recovery rates of global yield optima

    heatrecoveryoptima=([heatrecovery(pos) h(pos)]);
    heatrecoveryoptima=round(heatrecoveryoptima,2);

    % generate global yield plot

    figure('Name','Economic Analysis - Global Yields')
        plot(h,globalyield(:,1),'b')
        hold on
        plot(h,globalyield(:,2),'m')
        plot(h,globalyield(:,3),'r')
        plot(globalyieldoptima(1,2),globalyieldoptima(1,1),'bx')
        plot(globalyieldoptima(2,2),globalyieldoptima(2,1),'mx')
        plot(globalyieldoptima(3,2),globalyieldoptima(3,1),'rx')
        xlabel('riser height [m]')
        ylabel('global PAE yield in % [-]')
        legend('90% recovery rate','95% recovery rate','99% recovery rate','Location','southeast')
        L=string(['Optima: ;'...
                  num2str(globalyieldoptima(1,1)) ' % at ' num2str(globalyieldoptima(1,2)) ' meters for 90% recycle;'...
                  num2str(globalyieldoptima(2,1)) ' % at ' num2str(globalyieldoptima(2,2)) ' meters for 95% recycle;'...
                  num2str(globalyieldoptima(3,1)) ' % at ' num2str(globalyieldoptima(3,2)) ' meters for 99% recylce']);
        L=strsplit(L,';');
        text(2,14,L)

    % generate heat recovery potential plot

    figure('Name','Economic Analysis - Heat Recovery')
        plot(h,heatrecovery(:,1),'k')
        hold on
        plot(heatrecoveryoptima(1,2),heatrecoveryoptima(1,1),'bx','MarkerSize',10)
        plot(heatrecoveryoptima(2,2),heatrecoveryoptima(2,1),'mx','MarkerSize',10)
        plot(heatrecoveryoptima(3,2),heatrecoveryoptima(3,1),'rx','MarkerSize',10)
        xlabel('riser height [m]')
        ylabel('heat recovery potential [kW]')
        L=string(['heat recovery potential at global yield optimas: ;'...
                  num2str(heatrecoveryoptima(1,1)) ' kW for 90% recycle;'...
                  num2str(heatrecoveryoptima(2,1)) ' kW for 95% recycle;'...
                  num2str(heatrecoveryoptima(3,1)) ' kW for 99% recycle']);
        L=strsplit(L,';');
        text(1.5,100,L);

else                                     % execute analysis for only one recovery rate
                                         % to prevent 'overloading' of plots
            
        % calculating global yield for 95% o-xylene recovery rate
        
        feedwrecycleXYL(:,1)=(ICs(5)-results(:,5)*0.95);    % calculate feedrate required for recycle with recovery rate i
        globalyield(:,1)=(results(:,6))./feedwrecycleXYL(:,1)*100;   % global yield: ratio PAE produced / XYL fed
        

        % calculate potential heat recovery rate
        numint=(h(2,1)-h(1,1))*cumtrapz((results(:,7)-designparameters(9)));        % numeric integration of the temperature gradient
        heatrecovery(:,1)=designparameters(5)*pi*designparameters(8)*numint*3600;   % calculate cumulative heat recovery potential up to height h

end
    
economicresults=([globalyield heatrecovery]);
% output matrix of globalyield and heatrecovery potential results
end

%------------------------------------------------------------------------
% function creating standard plots

function []=createplots(plotresults,h)

% this function automatically creates all the standard plots of the
% processed data required in the brief

    % create simple plots of all parameters
    
x=('riser height [m]');

% phtalic anhydride yield plot
figure('Name','phthalic anhydride single pass yield')
plot(h,plotresults(:,1),'b')
xlabel(x)
ylabel('single pass yield of phthalic anhydride in %')
hold on
[maxyield, pos]=max(plotresults(:,1));      % find maximum yield and corresponding height
m=round(maxyield,2);                       % generate text box returning max yield and height to 2 DP
p=round(h(pos),2);
txt=['maximum single pass yield: ',num2str(m),'% at riser height of ',num2str(p),' m'];
plot(h(pos),maxyield,'xr','MarkerSize',11)  % mark point of max yield in plot
dim=[0.2 0.1 0.3 0.1];                      
annotation('textbox',dim,'String',txt,'FitBoxToText','on')
hold off

figure('Name','temperature profile')
plot(h,plotresults(:,13),'b')
xlabel('riser height [m]')
ylabel('bulk temperature [K]')

figure('Name','pressure profile')
plot(h,plotresults(:,14),'b')
xlabel(x)
ylabel('pressure [bar]')

figure('Name','o-xylene conversion')
plot(h,plotresults(:,2),'b')
xlabel(x)
ylabel('local conversion of o-xylene in %')

figure('Name','phthalic anhydride selectivity')
plot(h,plotresults(:,10),'b')
xlabel(x)
ylabel('phthalic anhydride selectivity')

figure('Name','CO selectivity')
plot(h,plotresults(:,11),'b')
xlabel(x)
ylabel('CO selectivity')

figure('Name','Carbon Monoxide to Carbon Dioxide')
plot(h,plotresults(:,12),'b')
xlabel(x)
ylabel('CO to CO_2')

figure('Name','composition profile')
subplot(2,1,1)
    plot(h,plotresults(:,3))
    hold on
    plot(h,plotresults(:,4))
    plot(h,plotresults(:,5))
    plot(h,plotresults(:,7))
    plot(h,plotresults(:,8))
    hold off
    xlabel(x)
    ylabel('mole fraction')
    legend('Carbon Dioxide','Carbon Monoxide','Water','o-Xylene','Phthalic Anhydride','Location','east')

subplot(2,1,2)
    hold on
    plot(h,plotresults(:,6))
    plot(h,plotresults(:,9))
    hold off
    xlabel('riser height [m]')
    ylabel('mole fraction')
    legend('Oxygen','Nitrogen','Location','east')
    
end

%--------------------------------------------------------------------------
% functions for OAT sensitivity testing

function []=sensitivitysetup(choices,i)

% this function iteratively generates a set of parameters and initial
% conditions which vary accordingly to the user input from S2 stored in the
% choices matrix

global designparameters preexponentialfactors activationenergies ...    % import global parameters
       ratelawparameters enthalpyparameters ICs ndotNITIC

designparameters=([2300 0.01 600 1.3 0.03 0.5 1300 0.096 610]);         % redefine them to ensure 
preexponentialfactors=([19.24 20.04 20.36 28.55 28.45]);                % variation always starts with 
activationenergies=([14987 15862 15862 16040 16040]);                   % initially given parameters
ratelawparameters=([429 2024 1.0001 0.4280 0]);
enthalpyparameters=([-128300 -1526200 -3273600 -265600 -139800]);

AVGMW=29.6321;                                                          % by same reasoning, redefine IC
molarfeedflow=designparameters(1)*designparameters(5)^2*pi/4/AVGMW;
ICs=([0 0 0 molarfeedflow*(1-designparameters(2))*0.21 molarfeedflow*designparameters(2) 0 designparameters(3) designparameters(4)*10^5]); 
ndotNITIC=molarfeedflow*(1-designparameters(2))*0.79;

varrange=choices(5);                                                    % transform variation range input
variation=1-([varrange varrange/2 0 -varrange/2 -varrange]);            % into evenly spaced array of variations

if choices(1) == 1      % variation of designparameters
    
    % ---------- iteratively vary choosen designparameter: ---------------- 
    designparameters(choices(2))=designparameters(choices(2))*variation(i);
    
    % ---------- update ICs accordingly: ----------------------------------
    AVGMW=29.6321;
    molarfeedflow=designparameters(1)*designparameters(5)^2*pi/4/AVGMW;
    ICs=([0 0 0 molarfeedflow*(1-designparameters(2))*0.21 molarfeedflow*designparameters(2) 0 designparameters(3) designparameters(4)*10^5]);    
    ndotNITIC=molarfeedflow*(1-designparameters(2))*0.79;
    
elseif choices(1) == 0  % variation or reactionparameters
    
    % --------- iteratively vary choosen reactionparameter: ---------------
    if choices(3) == 1
        preexponentialfactors(choices(4))=preexponentialfactors(choices(4))*variation(i);
    elseif choices(3) == 2
        activationenergies(choices(4))=activationenergies(choices(4))*variation(i);
    elseif choices(3) == 3
        ratelawparameters(choices(4))=ratelawparameters(choices(4))*variation(i);
    elseif choices(3) == 4
        enthalpyparameters(choices(4))=enthalpyparameters(choices(4))*variation(i);
    else
    end
end
% output are updated values of the global variable which vary as specified
% in S2 by the user
end

function []=sensitivityplots(sensitivityresults,choices,test,h)

% this function plots data obtained from the sensitivity analysis to
% graphically show the impact of the varied parameters on selected reactor
% performance indicators o-xylene conversion, PAE yield and selectivity, CO
% to CO2 ratio and the temperature profile.

% create legend and pre set x axis

varrange=choices(5)*100;                                               % transform variation range input in percent
variation=100-([varrange varrange/2 100 -varrange/2 -varrange]);       % into numerical value and then evalute  
variation=num2cell(variation);                                         % as % of design brief value, transform 
variation=cellfun(@num2str,variation, 'UniformOutput',false);          % back into string for legend creation

variation=strcat(variation,'%');                    % add % signs
variation{1,3}=('original value');                  % define reference data as such

L=(variation);                                      % predefine legend
x=('riser height [m]');                             % predefine x - axis title

% PAE yield

figure('Name','sensitivity analysis - figure 1')
plot(h,sensitivityresults(:,1),':r')
hold on
plot(h,sensitivityresults(:,7),'-.r')
plot(h,sensitivityresults(:,13),'k')
plot(h,sensitivityresults(:,19),'-.b')
plot(h,sensitivityresults(:,25),':b')
hold off
xlabel(x)
ylabel('Local Yield of Phthalic Anhydride [-]')
title(test,'Fontsize',9)
legend(L)

% XYL conversion

figure('Name','sensitivity analysis - figure 2')
plot(h,sensitivityresults(:,2),':r')
hold on
plot(h,sensitivityresults(:,8),'-.r')
plot(h,sensitivityresults(:,14),'k')
plot(h,sensitivityresults(:,20),'-.b')
plot(h,sensitivityresults(:,26),':b')
hold off
xlabel(x)
ylabel('Conversion of o-Xylene [-]')
title(test,'Fontsize',9)
legend(L)

% Temperature Profile

figure('Name','sensitivity analysis - figure 3')
plot(h,sensitivityresults(:,5),':r')
hold on
plot(h,sensitivityresults(:,11),'-.r')
plot(h,sensitivityresults(:,17),'k')
plot(h,sensitivityresults(:,23),'-.b')
plot(h,sensitivityresults(:,29),':b')
hold off
xlabel(x)
ylabel('Temperature [K]')
title(test,'Fontsize',9)
legend(L)

% PAE selectivity

figure('Name','sensitivity analysis - figure 4')
plot(h,sensitivityresults(:,3),':r')
hold on
plot(h,sensitivityresults(:,9),'-.r')
plot(h,sensitivityresults(:,15),'k')
plot(h,sensitivityresults(:,21),'-.b')
plot(h,sensitivityresults(:,27),':b')
hold off
xlabel(x)
ylabel('Phthalic Anhydride Selectivity [-]')
title(test,'Fontsize',9)
legend(L)

% CO to CO2 ratio

figure('Name','sensitivity analysis - figure 5')
plot(h,sensitivityresults(:,4),':r')
hold on
plot(h,sensitivityresults(:,10),'-.r')
plot(h,sensitivityresults(:,16),'k')
plot(h,sensitivityresults(:,22),'-.b')
plot(h,sensitivityresults(:,28),':b')
hold off
xlabel(x)
ylabel('CO to CO2 ratio [-]')
title(test,'Fontsize',9)
legend(L)

% global yield

figure('Name','sensitivity analysis - figure 6')
plot(h,sensitivityresults(:,6),':r')
hold on
plot(h,sensitivityresults(:,12),'-.r')
plot(h,sensitivityresults(:,18),'k')
plot(h,sensitivityresults(:,24),'-.b')
plot(h,sensitivityresults(:,30),':b')
hold off
xlabel(x)
ylabel({'Global Phthalic Anhydride Yield in %','(95% downstream o-Xylene recovery rate)'})
title(test,'Fontsize',9)
legend(L)


% output are 5 plots showing the results of the sensitivity analysis
end

%% Nomenclature:
% All components were abbreviated to three letter codes:
% XYL - o-xylene
% PAE - phthalic anhydride
% OXY - oxygen
% NIT - nitrogen
% CMX - carbon monoxide
% CDX - carbon dioxide
% WAT - water

% the following other abbrevations were used:
% ndot - molar flowrate [kmol/hr]
% c - concentration [kmol/m³]
% d/dz - derivative wrt riser height
% IC - initial condition
% h - riser height [m]

