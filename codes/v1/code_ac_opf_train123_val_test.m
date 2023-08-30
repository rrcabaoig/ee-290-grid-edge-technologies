% Perform multiple AC OPF runs to get the optimal generator Pg and V
% For training, validation, and test sets
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

for train_group = 1:3
    clear pg_v_train;

    pd_qd_train_file = sprintf('pd_qd_train_%d.csv', train_group);
    pd_qd_train_file_path = fullfile('..\data\', pd_qd_train_file);
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

    pg_v_train_file = sprintf('pg_v_train_%d.csv', train_group);
    pg_v_train_file_path = fullfile('..\data\', pg_v_train_file);
    writecell(pg_v_train, pg_v_train_file_path);
end

%%% ========== Validation Set (pd, qd) -> (pg, v) ========== %%%

clear pg_v_val;

pd_qd_val_file_path = '..\data\pd_qd_val.csv';
pd_qd_val = readmatrix(pd_qd_val_file_path);

mpc = loadcase('case33rrc');

for row = 1:3456
    for col = 1:2:65
        if col == 1
            pg_v_val(row, 1) = pd_qd_val(row, 1);
        else
            mpc.bus((col + 1)/2, PD) = pd_qd_val(row, col - 1);
            mpc.bus((col + 1)/2, QD) = pd_qd_val(row, col);
        end
    end

    results = runopf(mpc);
    pg_v_val(row, 2) = results.gen(1, PG);
    pg_v_val(row, 3) = results.gen(2, PG);
    pg_v_val(row, 4) = results.bus(18, VM);
    pg_v_val(row, 5) = results.gen(3, PG);
    pg_v_val(row, 6) = results.bus(22, VM);
    pg_v_val(row, 7) = results.gen(4, PG);
    pg_v_val(row, 8) = results.bus(25, VM);
    pg_v_val(row, 9) = results.gen(5, PG);
    pg_v_val(row, 10) = results.bus(33, VM);
end

pg_v_val = [headers; num2cell(pg_v_val)];

pg_v_val_file_path = '..\data\pg_v_val.csv';
writecell(pg_v_val, pg_v_val_file_path);

%%% ========== Test Set (pd, qd) -> (pg, v) ========== %%%

clear pg_v_test;

pd_qd_test_file_path = '..\data\pd_qd_test.csv';
pd_qd_test = readmatrix(pd_qd_test_file_path);

mpc = loadcase('case33rrc');

for row = 1:3552
    for col = 1:2:65
        if col == 1
            pg_v_test(row, 1) = pd_qd_test(row, 1);
        else
            mpc.bus((col + 1)/2, PD) = pd_qd_test(row, col - 1);
            mpc.bus((col + 1)/2, QD) = pd_qd_test(row, col);
        end
    end

    results = runopf(mpc);
    pg_v_test(row, 2) = results.gen(1, PG);
    pg_v_test(row, 3) = results.gen(2, PG);
    pg_v_test(row, 4) = results.bus(18, VM);
    pg_v_test(row, 5) = results.gen(3, PG);
    pg_v_test(row, 6) = results.bus(22, VM);
    pg_v_test(row, 7) = results.gen(4, PG);
    pg_v_test(row, 8) = results.bus(25, VM);
    pg_v_test(row, 9) = results.gen(5, PG);
    pg_v_test(row, 10) = results.bus(33, VM);
end

pg_v_test = [headers; num2cell(pg_v_test)];

pg_v_test_file_path = '..\data\pg_v_test.csv';
writecell(pg_v_test, pg_v_test_file_path);