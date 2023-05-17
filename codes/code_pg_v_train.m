% Perform multiple AC OPF runs to get the optimal generator Pg and V
clear;
define_constants;

headers{1} = 'scenario';
headers{2} = 'pg_1';
headers{3} = 'v_1';
headers{4} = 'pg_18';
headers{5} = 'v_18';
headers{6} = 'pg_22';
headers{7} = 'v_22';
headers{8} = 'pg_25';
headers{9} = 'v_25';
headers{10} = 'pg_33';
headers{11} = 'v_33';

for train_group = 1:3
    clear pg_v_train;

    input_file = sprintf('pd_qd_train_%d.csv', train_group);
    input_file_path = fullfile('..\data\', input_file);
    pd_qd_train = readmatrix(input_file_path);
    
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
        pg_v_train(row, 3) = results.bus(1, VM);
        pg_v_train(row, 4) = results.gen(2, PG);
        pg_v_train(row, 5) = results.bus(18, VM);
        pg_v_train(row, 6) = results.gen(3, PG);
        pg_v_train(row, 7) = results.bus(22, VM);
        pg_v_train(row, 8) = results.gen(4, PG);
        pg_v_train(row, 9) = results.bus(25, VM);
        pg_v_train(row, 10) = results.gen(5, PG);
        pg_v_train(row, 11) = results.bus(33, VM);
    end

    pg_v_train = [headers; num2cell(pg_v_train)];

    output_file = sprintf('pg_v_train_%d.csv', train_group);
    output_file_path = fullfile('..\data\', output_file);
    writecell(pg_v_train, output_file_path);
end