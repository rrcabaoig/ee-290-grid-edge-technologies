% Perform multiple AC OPF runs to get the optimal generator Pg and V
% For test set wherein there is a simultaneous increase in load in all buses
% 97.5 percent to 102.5 percent of the given max Pd per bus
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

%%% ========== Test Set: Simultaneous Increase in Load (pd, qd) -> (pg, v) ========== %%%

clear pg_v_test_load_increase;

pd_qd_test_load_increase_file_path = '..\data\pd_qd_test_load_increase.csv';
pd_qd_test_load_increase = readmatrix(pd_qd_test_load_increase_file_path);

mpc = loadcase('case33rrc');

for row = 1:3552
    for col = 1:2:65
        if col == 1
            pg_v_test_load_increase(row, 1) = pd_qd_test_load_increase(row, 1);
        else
            mpc.bus((col + 1)/2, PD) = pd_qd_test_load_increase(row, col - 1);
            mpc.bus((col + 1)/2, QD) = pd_qd_test_load_increase(row, col);
        end
    end

    results = runopf(mpc);
    pg_v_test_load_increase(row, 2) = results.gen(1, PG);
    pg_v_test_load_increase(row, 3) = results.gen(2, PG);
    pg_v_test_load_increase(row, 4) = results.bus(18, VM);
    pg_v_test_load_increase(row, 5) = results.gen(3, PG);
    pg_v_test_load_increase(row, 6) = results.bus(22, VM);
    pg_v_test_load_increase(row, 7) = results.gen(4, PG);
    pg_v_test_load_increase(row, 8) = results.bus(25, VM);
    pg_v_test_load_increase(row, 9) = results.gen(5, PG);
    pg_v_test_load_increase(row, 10) = results.bus(33, VM);
end

pg_v_test_load_increase = [headers; num2cell(pg_v_test_load_increase)];

pg_v_test_load_increase_file_path = '..\data\pg_v_test_load_increase.csv';
writecell(pg_v_test_load_increase, pg_v_test_load_increase_file_path);