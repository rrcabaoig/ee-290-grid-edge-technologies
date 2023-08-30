% Perform multiple AC OPF runs to get the optimal generator Pg and V
% For test sets wherein solar pv and wind resources have been included
% bus 4: wind, 0.96 lead cpfm
% bus 10: solar pv, unity cpfm
% bus 14: solar pv, 0.97 lead cpfm
% bus 16: wind, unity cpfm
% bus 20: solar pv, unity cpfm
% bus 23: wind, unity cpfm
% bus 30: solar pv, 0.95 lead cpfm
% The peak ac output of each resource is set at
% 15pct, 30pct, 45pct, and 60pct of the peak load of each bus
clear;
define_constants;

headers{1} = 'scenario';
headers{2} = 'pg_1';
headers{3} = 'pg_18';
headers{4} = 'v_18';
headers{5} = 'pg_22';
headers{6} = 'v_22';
headers{7} = 'pg_25';
headers{8} = 'v_25';
headers{9} = 'pg_33';
headers{10} = 'v_33';

%%% ========== Test Set: Solar PV and Wind Installation (pd, qd) -> (pg, v) ========== %%%

for pct_peak = 15:15:60
    clear pg_v_test_solar_wind;
    
    pd_qd_test_solar_wind_file = sprintf('pd_qd_test_solar_wind_%d_pct.csv', pct_peak);
    pd_qd_test_solar_wind_file_path = fullfile('..\data\', pd_qd_test_solar_wind_file);
    pd_qd_test_solar_wind = readmatrix(pd_qd_test_solar_wind_file_path);
    
    mpc = loadcase('case33rrc');
    
    for row = 1:3552
        for col = 1:2:65
            if col == 1
                pg_v_test_solar_wind(row, 1) = pd_qd_test_solar_wind(row, 1);
            else
                mpc.bus((col + 1)/2, PD) = pd_qd_test_solar_wind(row, col - 1);
                mpc.bus((col + 1)/2, QD) = pd_qd_test_solar_wind(row, col);
            end
        end
    
        results = runopf(mpc);
        pg_v_test_solar_wind(row, 2) = results.gen(1, PG);
        pg_v_test_solar_wind(row, 3) = results.gen(2, PG);
        pg_v_test_solar_wind(row, 4) = results.bus(18, VM);
        pg_v_test_solar_wind(row, 5) = results.gen(3, PG);
        pg_v_test_solar_wind(row, 6) = results.bus(22, VM);
        pg_v_test_solar_wind(row, 7) = results.gen(4, PG);
        pg_v_test_solar_wind(row, 8) = results.bus(25, VM);
        pg_v_test_solar_wind(row, 9) = results.gen(5, PG);
        pg_v_test_solar_wind(row, 10) = results.bus(33, VM);
    end
    
    pg_v_test_solar_wind = [headers; num2cell(pg_v_test_solar_wind)];
    
    pg_v_test_solar_wind_file = sprintf('pg_v_test_solar_wind_%d_pct.csv', pct_peak);
    pg_v_test_solar_wind_file_path = fullfile('..\data\', pg_v_test_solar_wind_file);
    writecell(pg_v_test_solar_wind, pg_v_test_solar_wind_file_path);
end