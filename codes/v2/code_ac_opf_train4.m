% Perform multiple AC OPF runs to get the optimal generator Pg and V
% For training set 4 - OPFLearn
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

%%% ========== Training Set (pd, qd) -> (pg, v) ========== %%%

clear pg_v_train;

pd_qd_train_file_path = '..\data\pd_qd_train_4.csv';
pd_qd_train = readmatrix(pd_qd_train_file_path);

mpc = loadcase('case33rrc');

for row = 1:28032
    for col = 1:2:65
        if col == 1
            pg_v_train(row, 1) = pd_qd_train(row, 1);
        else
            mpc.bus((col + 1)/2, PD) = pd_qd_train(row, col - 1);
            mpc.bus((col + 1)/2, QD) = pd_qd_train(row, col);
        end
    end
    
    results = runopf(mpc);
    pg_v_train(row, 2) = results.gen(1, PG);
    pg_v_train(row, 3) = results.gen(2, PG);
    pg_v_train(row, 4) = results.bus(18, VM);
    pg_v_train(row, 5) = results.gen(3, PG);
    pg_v_train(row, 6) = results.bus(22, VM);
    pg_v_train(row, 7) = results.gen(4, PG);
    pg_v_train(row, 8) = results.bus(25, VM);
    pg_v_train(row, 9) = results.gen(5, PG);
    pg_v_train(row, 10) = results.bus(33, VM);
end

pg_v_train = [headers; num2cell(pg_v_train)];

pg_v_train_file_path = '..\data\pg_v_train_4.csv';
writecell(pg_v_train, pg_v_train_file_path);