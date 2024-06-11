% Writes a .mif file from an RGB image resized to fit the memory limits of the board.
% Each address contains a 24bit RGB pixel

write_mif('kodim23.png', 'kodim23.mif');

function write_mif(filename, out_filename)
    fprintf('[%s]\n', out_filename);

    if (strcmp(filename, out_filename) == 1)
        error('Output file must be different from input file.');
    end

    path = './images/';
    pixel_depth = 24; % Full color

    img = imread(strcat(path, filename));
    resized = resize_to_fit_memory(img, pixel_depth, [200, NaN]);

    [height, width, ~] = size(resized);
    required_bits = get_required_bits(resized, pixel_depth);
    maximum_bits = get_maximum_bits();

    memory_size = height * width;
    word_length = pixel_depth;

    fid = fopen(strcat(path, out_filename), 'w');
    fprintf(fid, 'DEPTH=%d;\n', memory_size);
    fprintf(fid, 'WIDTH=%d;\n', word_length);
    fprintf(fid, 'ADDRESS_RADIX = UNS;\n');
    fprintf(fid, 'DATA_RADIX = HEX;\n');
    fprintf(fid, 'CONTENT\t');
    fprintf(fid, 'BEGIN\n');

    for col = 1:width
        for row = 1:height
            r = resized(row, col, 1);
            g = resized(row, col, 2);
            b = resized(row, col, 3);
            hex = sprintf('%02x%02x%02x', r, g, b);
            
            index = (row - 1) + (col - 1) * height;
            fprintf(fid, '\t%d\t:\t%s;\n', index, hex);
        end
    end

    fprintf(fid, 'END;\n');
    fclose(fid);

    address_width = ceil(log2(memory_size));
    fprintf('[%s]\n\tHeight: %d\n\tWidth: %d\n\tMemory size: %d\n\tPixel depth: %db\n\tAddress Width: %d\n\tRAM usage: %d bits (%.2f%%)\n\n', out_filename, height, width, memory_size, pixel_depth, address_width, required_bits, required_bits / maximum_bits * 100);
    
    [~, ~, in_extension] = fileparts(filename);
    [~, out_name, ~] = fileparts(out_filename);
    imwrite(resized, strcat(path, out_name, '_resized', in_extension));
end

function result = resize_to_fit_memory(img, pixel_depth, target_size)
    if (target_size(1) == 0)
        error('Could not fit image inside constraints')
    end

    resized = imresize(img, target_size);

    required_bits = get_required_bits(resized, pixel_depth);
    % Adds some margin as the FPGA memory needs to be arranged differently
    maximum_bits = get_maximum_bits() * 0.8;

    if (required_bits > maximum_bits)
        result = resize_to_fit_memory(img, pixel_depth, [target_size(1) - 1, NaN]);
    else
        result = resized;
    end
end

% Maximum memory size on the FPGA board
function bits = get_maximum_bits()
    bits = 276480;
end

function bits = get_required_bits(img, pixel_depth)
    bits = size(img, 1) * size(img, 2) * pixel_depth;
end