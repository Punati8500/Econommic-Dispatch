%% Economic load dispatch at Critical hour

clc;
clear all;
%% Reading data from task sheet

Load = 823.65;              %% Power demand (MWh) at critical hour %%
data = xlsread('input');    %% data about Gas turbines from the input %%
a = data(:,2);              %% a (€) values from fuel cost curves of Gas turbines %%
b = data(:,3);              %% b (€/MWh) values from fuel cost curves of Gas turbines %% 
c = data(:,4);              %% c (€/MWh^2)values from fuel cost curves of Gas turbines %%
Minimum_Capacity = data(:,5);     %%  Minimum capacitiy (MW) values of Gas turbines %%
Maximum_Capacity = data(:,6);     %%  Maximum capacitiy (MW) values of Gas turbines %%
Power_Demand = Load;
Lambda = max(b);                  %% assumed lambda value to solve the problem %%

%% Calculating the power demand share by each gas turbine

while abs(Power_Demand)>0.00001   %% Transmission losses are neglected %%
    multiplier = (Lambda-b)/2;
    P = multiplier./c;
    P = min(P,Maximum_Capacity);
    P = max(P,Minimum_Capacity);
    Power_Demand = Load-sum(P);
    Lambda = Lambda+Power_Demand*2/(sum(1./c));
end

%% Calculating the fuel cost of each gas turbine

Fuel_Cost = a+b.*P+c.*P.*P;      %% Fuel cost (€) of the Gas turbines F = a + bP+ cP^2 %%
total_Fuel_Cost = sum(Fuel_Cost);  %% Total fuel cost (€) of the plant to meet the demand %%

%% Output

display(total_Fuel_Cost);
table(data(:,1),P,Fuel_Cost,'V',{'Unit' 'Power_Produced' 'Fuel_Cost'})