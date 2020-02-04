function [Hot_Utility,Cold_Utility,Pinch_Point] = PTA(DT_min)

disp(['Minimum Difference of Temperatures(DT_min) = ' , num2str(DT_min) , ' C'])
%number of streams
n = input('Number of Streams = ','s');
N = str2double(n);
Streams = {};

for i=1:N
    Streams{i,1} = num2str(i);
end
supply_temps = zeros(N,1);
target_temps = zeros(N,1);
mCp = zeros(N,1);
DH = zeros(N,1);
Delta_T = zeros(N,1);
for i=1:N
    disp('-----------------------------------------')
    supply_temps(i,1) = input(['Stream number ' , num2str(i) , ' Supply Temperature in C = ']);
    target_temps(i,1) = input(['Stream number ' , num2str(i) , ' Target Temperature in C = ']);
    mCp(i,1) = input(['Stream number ' , num2str(i) , ' mCp = ']);
    disp('-----------------------------------------')
    DH(i,1) = mCp(i,1) .* (target_temps(i,1) - supply_temps(i,1));
    Delta_T(i,1) =abs( target_temps(i,1) - supply_temps(i,1));
end
table(Streams,supply_temps,target_temps,mCp,DH)
Delta_T
% Shifitng temperatures code 
hot_shift = -DT_min / 2 ;
cold_shift = DT_min / 2 ;
shifted_target = zeros(N,1);
shifted_supply = zeros(N,1);
for i=1:N
    if DH(i) < 0 
       shifted_supply(i,1) =  supply_temps(i) + hot_shift;
       shifted_target(i,1) = target_temps(i) + hot_shift;
    elseif DH(i) > 0
       shifted_supply(i,1) =  supply_temps(i) + cold_shift;
       shifted_target(i,1) =  target_temps(i) + cold_shift;
    end
end

table(Streams,supply_temps,target_temps,shifted_supply,shifted_target) 
%+% first thing to do is to run and check the table and 
%+% then i need to write the algorithms for finding pinch point 
temps = vertcat(shifted_supply , shifted_target);
temps = sort(temps,'descend');
n_t = size(temps); % size has 2 arguments like 2 * 1 for 2 rows and 1 column matrix
DT_interval = zeros(n_t(1)-1,1);
sum_mCp_cold = 0;
sum_mCp_hot = 0;

for i = 1 : (n_t(1)-1)
    disp(['Interval Number ',num2str(i),' : ',num2str(temps(i)),' -- ',num2str(temps(i+1))])
    DT_interval(i) = temps(i) - temps(i+1);
end

tmps_for_cold = sort(temps);

for j= 1 : N
    for i = 1 : (n_t(1) - 1)
        % shifted_target , shifted_supply ==== > temps(i) , temps(i+1)
        % for cold stream : shifted_target , tmps_for_cold(i)
        % for cold stream : shifted_supply , tmps_for_cold(i+1)
        if DH(j) > 0
           % shifted_supply ?= tmps_for_cold
           diff_sup = shifted_supply(j) - tmps_for_cold(i);
           
           if diff_sup == 0 
               i
               disp(['Supply is ' , num2str(tmps_for_cold(i))])
           end
        elseif DH(j) < 0
            % for hot stream : shifted_target , temps(i+1)
            % for hot stream : shifted_supply , temps(i)
            
        end
    end
end

for j= 1 : N
    for i = 1 : (n_t(1) - 1)
        % shifted_target , shifted_supply ==== > temps(i) , temps(i+1)
        % for cold stream : shifted_target , tmps_for_cold(i)
        % for cold stream : shifted_supply , tmps_for_cold(i+1)
        if DH(j) > 0
           % shifted_supply ?= tmps_for_cold
           diff_tar = shifted_target(j) - tmps_for_cold(i);
           
           if diff_tar == 0 
               i
               disp(['Target is ' , num2str(tmps_for_cold(i))])
           end
        elseif DH(j) < 0
            % for hot stream : shifted_target , temps(i+1)
            % for hot stream : shifted_supply , temps(i)
          
        end
    end
end




