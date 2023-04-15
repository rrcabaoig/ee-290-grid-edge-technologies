clear;
snapshot = readmatrix('..\data\snapshot.csv');

headers{1} = 'scenario';
col = 2;
for bus = 2:33
    header = sprintf('pd_%d', bus);
    headers{col} = header;
    col = col + 1;
    header = sprintf('qd_%d', bus);
    headers{col} = header;
    col = col + 1;
end

for a = 1:3
    for b = 1:4
        bus_pd_qd_train = zeros(864, 65);

        input_file = sprintf('sys_pd_train_%d_%d.csv', a, b);
        input_file_path = fullfile('..\data\sys_pd_train\', input_file);
        sys_pd_train = readmatrix(input_file_path);

        for row = 1:864
            bus = 2;
            for col = 1:2:65
                if col == 1
                    bus_pd_qd_train(row, col) = sys_pd_train(row, 1);
                else
                    bus_pd_qd_train(row, col - 1) = sys_pd_train(row, 3)*snapshot(bus, 2);
                    bus_pd_qd_train(row, col) = sys_pd_train(row, 3)*snapshot(bus, 3);
                    bus = bus + 1;
                end
            end
        end

        output_file = sprintf('bus_pd_qd_train_%d_%d.csv', a, b);
        output_file_path = fullfile('..\data\bus_pd_qd_train\', output_file);
        writecell([headers; num2cell(bus_pd_qd_train)], output_file_path);

        fprintf("Done saving %s.\n", output_file_path);
    end
end