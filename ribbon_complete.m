function [T_rib_hottest,I_max] = ribbon_complete(l,w,h,t_heat,V,t_cool,n_pulses)

dif_heat = 100; % number of times the heating while loop runs
dif_cool = 100; % number of times the cooling while loop runs

T_sink = 300; % temperature of the electrical leads (K)
T_rib = T_sink; % initial temperature of ribbon (K)
s = 5.67*10^-8; % Stephann-Boltzmann constant (W/m^2-K^4)
e = 0.7; % emmissivity of rough stainless steel (unitless)
d = 8*10^6; % density of stainless steel (g/m^3)
C = 0.466; % heat capacity of stainless steel (J/g-K)
p = 5.61*10^-7+6.11*10^-10*T_rib; % resistivity of 302 stainless steel (ohm-m)

Vol = l*w*h; % volume (m^3)
A_res = w*h; % resistance cross section (m^2)
A_cond = w*h; % area of conduction to electrical leads (m^2)
A_rad = w*l; % area of radiation (m^2)
m = Vol*d; % mass (g)

R_rib = p*l/A_res; % initial resistance of ribbon (ohm)
R_leads = 0.15; % empirically determined resistance of leads (ohm)
R = R_rib + R_leads; % total resistance of circuit
I = V/R; % initial current (A)

I_max = I; % max current (A)

T_heat_vec = []; % initiating T_heat_vec
t_heat_vec = []; % initiating t_heat_vec
T_cool_vec = []; % initiating T_cool_vec
t_cool_vec = []; % initiating t_cool_vec
T_complete = [300]; % initiating T_complete
t_complete = [0]; % initiating t_complete
T_rib_hot = []; % initiating T_rib_hot

h = 0; % initiating counter

while h <= n_pulses-1

i = t_heat/dif_heat; % initiating counter

while i <= t_heat
    p = 5.61*10^-7+6.11*10^-10*T_rib; % resistivity of 302 stainless steel (ohm-m)
    R_rib = p*l/A_res; % resistance of ribbon (ohm)
    R = R_rib + R_leads; % total resistance of circuit
    I = V/R; % current through ribbon (A)
    P_rad = s*e*A_rad*T_rib^4; % rate of cooling due to radiation
    P_sink = s*e*A_rad*T_sink^4; % rate of heating due to conductivity
    P_res = I^2*R_rib; % rate of heating due to radiation
    Q = (P_res + P_sink - P_rad)*t_heat/dif_heat; % heat from current pulse (J)
    del_T = Q/(C*m); % change in T (K)
    T_rib = del_T + T_rib; % final temperature (K)
    T_heat_vec = [T_heat_vec T_rib]; % adding temperature to T_heat_vec (K)
    t_heat_vec = [t_heat_vec i+h*(t_heat+t_cool)]; % adding i to t_heat_vec
    i = i + t_heat/dif_heat; % makes while loop run dif_heat times
end

Q = C*m*T_rib; % heat of the hot ribbon (J)

j = t_cool/dif_cool; % initiating counter

while j <= t_cool
    k = 11.544 + 1.28*10^-2*T_rib; % thermal conductivity of stainless steel (W/m-K)
    P_cond = k*A_cond*del_T/(l/2); % rate of cooling due to conduction
    P_rad = s*e*A_rad*T_rib^4; % rate of cooling due to radiation
    P_sink = s*e*A_rad*T_sink^4; % rate of heating due to radiation
    del_Q = (P_sink - P_rad - P_cond)*t_cool/dif_cool; % heat change (J)
    Q = Q + del_Q; % new heat of ribbon (J)
    T_rib = Q/(C*m); % new temperature of ribbon (K)
    del_T = T_rib - T_sink; % redefining the new difference (K)
    T_cool_vec = [T_cool_vec T_rib]; % adding temperature to T_cool_vec (K)
    t_cool_vec = [t_cool_vec j+h*(t_heat+t_cool)]; % adding j to t_cool_vec
    j = j + t_cool/dif_cool; % makes while loop run dif times
end

T_complete = [T_complete T_heat_vec]; % adds heating temperatures to T_complete
T_complete = [T_complete T_cool_vec]; % adds cooling temperatures to T_complete
T_heat_vec = []; % clears T_heat_vec
T_cool_vec = []; % clears T_cool_vec

t_cool_vec = t_cool_vec + t_heat; % adds t_heat to t_cool_vec
t_complete = [t_complete t_heat_vec]; % adds heating time to t_complete
t_complete = [t_complete t_cool_vec]; % adds cooling time to t_complete
t_heat_vec = []; % clears t_heat_vec
t_cool_vec = []; % clears t_cool_vec

h = h +1; % makes while loop run n_pulses times

end

T_rib_hottest = max(T_complete); % hottest temperature achieved

t_targ = [0 t_complete(end)]; % first and last times

plot(t_complete,T_complete) % plots the figure
title('Temperature of Ribbon vs. Time') % creates title
xlabel('Time (s)') % labels the x-axis
ylabel('Temperature (K)') % labels the y-axis

end
