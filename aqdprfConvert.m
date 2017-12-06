function aqdprfConvert(src,des,prefix,do)
% src:      source file ('c:\data\prffile')DON'T include the src filename extension (.prf)
% des:      destination directory
% prefix:   prefix added to .mat files, defaults to .prf filename
%
% do:       indice for only processing subset of wavebursts, e.g.
%           1312:1500, otherwise processes entire file
%
% Example Call:
% src = 'd:\_data\guam\A3';
% des = 'd:\_data\guam\beta output\';
% aqdprfConvert(src,des,'A3')

% single precision would have been sufficient

s = strfind(src,'\');
p = strfind(src,'.');
if s(end) == length(src), s = s(end-1); else, s = s(end); end
if p &gt; s, src = src(1:p-1); end
if nargin == 2, prefix = src(s+1:end); end
clear s p

wad = '.wad';

if des(end) ~= '\', des = [des '\']; end
if exist('des','dir') ~= 7, mkdir(des), end

% DO NOT edit these, relative ordering
field = {'Amp1';'Amp2';'Amp3';'Sen';'Vel1';'Vel2';'Vel3';'Whd';};
% from above, I'm using all of the ASCII data files, except for the readme
source = {'.a1';'.a2';'.a3';'.sen';'.v1';'.v2';'.v3';'.whd'};
hfield = {'Number of measurements','Number of checksum errors','Time of first measurement',...
    'Time of last measurement','Profile interval','Number of cells','Cell size',...
    'Average interval','Measurement load','Transmit pulse length','Blanking distance',...
    'Wave - Powerlevel','Wave - Interval','Wave - Number of samples',...
    'Wave - Sampling rate','Wave - Cell size','Coordinate System','Number of pings per burst',...
    'Serial Number'};
sfield = {'Time';'Error_Code';'Status_Code';'Battery_Voltage';'Soundspeed';...
    'Heading';'Pitch';'Roll';'Pressure';'Temperature';'Analog_Input_1';...
    'Analog_Input_2'};
wfield = {'Time';'Burst_Counter';'Num_Wave_Samples';'Cell_Position';...
    'Battery_Voltage';'Soundspeed';'Heading';'Pitch';'Roll';'Min_Pressure';...
    'Max_Pressure';'Temperature';'Cell_Size';'Noise_Amp_1';'Noise_Amp_2';...
    'Noise_Amp_3';'Noise_Amp_4';'AST_Window_Start';'AST_Window_Size'};
bfield = {'Time','Pressure','Analog','Velocity_1','Velocity_2','Velocity_3',...
    'Amplitude_1','Amplitude_2','Amplitude_3'};

%-------------------------------------------------------------------------%
% Grab the Header file and some essential parameters:
%-------------------------------------------------------------------------%
fid = fopen([src '.hdr']);
x = textscan(fid,'%s','Delimiter','\r'); x = x{:}; prf.Header = x;
fclose(fid);

for n = 1:length(hfield)
    for m = 1:length(x)
        si = strfind(x(m),hfield{n});
        if ~isempty(si{:})
            ni = strfind(hfield{n},' ');
            ni = [ni strfind(hfield{n},'-')];
            hfield{n}(ni) = '_';
            value = x{m}(length(hfield{n})+1:end);
            if ~isempty(str2num(value)), prf.Hdr.(hfield{n}) = str2num(value);
            elseif 1
                try prf.Hdr.(hfield{n}) = datenum(value);
                catch
                    for p = 1:length(value)
                        zi(p) = ~isempty(str2num(value(p)));
                    end
                    zi = find(zi,1,'last');
                    if strcmp(value(zi+2:end),'cm'), unit = 0.01; else, unit = 1; end
                    prf.Hdr.(hfield{n}) = unit * str2num(value(1:zi));
                end
            end
            break
        end
    end
end, clear n m p ni si zi x name value
%-------------------------------------------------------------------------%
% Parse all data files: (except .wad)
%-------------------------------------------------------------------------%
% source{4}: Sensor
% source{8}: Wave Header
for n = 1:length(field)
    dateconv = any(strcmp(source{n},source([4 8])));% flag for date conversion to matlab datenum
    [N,str] = findColumns([src source{n}]);
    fid = fopen([src source{n}]);
    if strcmp(source{n},source{4}), str = [repmat('%n',1,6) '%s%s' repmat('%n',1,N-8)]; end
    textout = textscan(fid,str);
    if dateconv, textout = fixTime(textout); end
    if strcmp(source{n},source{4})
        prf.(field{n}) = sensorFields(textout);
    elseif strcmp(source{n},source{8})
        for m = 1:length(textout)
            prf.(field{n}).(wfield{m}) = collapseScalar(textout{m});
        end
    else
        for m = 1:length(textout)
            prf.(field{n})(:,m) = textout{:,m};
        end
    end
    fclose(fid);
end
clear textout
errorCheckProfile
errorCheckWaveHeader
nburst = length(prf.(field{8}).(wfield{1}));
save([des prefix '~Profile'],'prf')

%-------------------------------------------------------------------------%
% Now the .WAD file
%-------------------------------------------------------------------------%
[N,str] = findColumns([src wad]);
if N == 13
    samplebytes = 95;% bytes per sample
elseif N == 17
    samplebytes = 105;
else
    error('.WAD data file has unknown format')
end
fid = fopen([src wad]);
% should be able to pass:prf.(field{8}).(wfield{3})(1); as the burst
% length, damned if i can't figure out why it loads entire text file
% instead
h = waitbar(0,'Converting Aquadopp Profiler data (ASCII &gt;&gt; .mat)');
if nargin &lt; 4, do = 1:nburst; end% process every waveburst
if do(1) ~= 1 % seek into the file if not starting at the beginning
    ferr = fseek(fid,(do(1)-1)*samplebytes*prf.Hdr.(hfield{14}),-1);
    if ferr == -1; error(ferror(fid)); end
end
for nb = do % NOTE: nb is also used in the nested function errorCheckWave
    waitbar(nb/nburst)
    wav = textscan(fid,str,prf.Hdr.(hfield{14}));
    if ~isempty(wav)
        wav = waveBurstFields(wav);
        save([des prefix '_' sprintf('%05.0f',nb)],'wav')
    end
end
close(h)
fclose(fid);
%-------------------------------------------------------------------------%
% Begin Nested Functions:
%-------------------------------------------------------------------------%
    function c = aqdCellPositions(cell_size,blank_size,N_cells)
        % function c = aqdCellPositions(cell_size,blank_size,N_cells)
        % returns Aquadopp Profiler cell positions
        % rows of "c" correspond to each cell, from near to far
        % column 1:  cell centers
        % column 2:  absolute minimum range
        % column 3:  absolute maximum range
        % column 4:  nominal minimum range  (%75 of measurement volume)
        % column 5:  nominal maximum range
        c(:,1) = blank_size + cell_size*[1:N_cells];
        c(:,2) = blank_size + cell_size*[0:N_cells-1];
        c(:,3) = blank_size + cell_size*[2:N_cells+1];
        c(:,4) = blank_size + cell_size/2 + cell_size*[0:N_cells-1];
        c(:,5) = blank_size + cell_size/2 + cell_size*[1:N_cells];
    end
    function [N,str] = findColumns(fname)
        % determine number of columns in text file:
        [fid,message] = fopen(fname);
        chk = textscan(fid,'%n','EndOfLine','\r');
        N = length(chk{1});
        fclose(fid);
        % construct text format string:
        str = repmat('%n',1,N);
    end
    function x = fixTime(x)% convert columns 1:6 to matlab datenum
        x{:,1} = datenum([x{:,[3 1 2 4:6]}]);
        x(:,2:6) = [];
    end
    function x = collapseScalar(x)
        if all(x == x(1))% if vector is constant, reduce to scalar
            x = x(1);
        else, x = x;
        end
    end
    function out = sensorFields(in)
        for nn = 1:length(sfield)
            if any(nn == [2,3])% convert error and status words to logic
                nns = length(in{nn});
                word = reshape(logical(str2num([in{nn}{:}]')),8,nns)';
                out.(sfield{nn}) = word;
            else% simply parse the other fields
                out.(sfield{nn}) = in{nn};
            end
        end
        % variable "word" is still the status code, extract wakeup state and power levels from it:
        bitstate = [0 0;0 1;1 0;1 1];
        for nbs = 1:4
            bstate = repmat(bitstate(nbs,:),nns,1);
            out.Wakeup_State(all(word(:,[5,6])' == bstate')) = nbs;
            out.Power_Level(all(word(:,[7,8])' == bstate')) = nbs;
        end
        out.Wakeup_State = out.Wakeup_State'; out.Power_Level = out.Power_Level';
        out.Power_Level = collapseScalar(out.Power_Level);% if Power Level is constant, reduce to scalar
        out.(sfield{5}) = collapseScalar(out.(sfield{5}));% if Soundspeed is constant, reduce to scalar
        clear word bstate
        out.Wakeup_States = {'Bad power';'Power supplied';'Break';'Real Time Clock'};
        out.Power_Levels = {'High';'High -';'Low +';'Low'};
    end
    function out = waveBurstFields(wav)
        if N == 17, wav = fixTime(wav); end
        wav = errorCheckWaveBurst(wav);
        if N == 13, b2field = bfield(2:end); bi = [1 3 4:6 8:10];
            for n = 1:length(b2field)
                out.(b2field{n}) = wav{bi(n)};
            end
        end
    end
    function errorCheckProfile
        % field{4} is the Sensor
        % field{8} is the Header
        nns = length(prf.(field{4}).(sfield{1}));
        if any(prf.(field{4}).(sfield{2})(:))
            figure, imagesc(prf.(field{4}).(sfield{2}))
            error('ERRORS FOUND (need to add error-handling capability')
        end
        warns = {'Status Word reports Wakeup State as "Bad Power" more than 5% of the time';...
            'Status Word reports Pitch as "out of range" more than 5% of the time';...
            'Status Word reports Roll as "out of range" more than 5% of the time'};
        if sum(prf.(field{4}).Wakeup_State == 1)/nns &gt; 0.05
            warning(warns{1})
            figure, subplot(2,1,1), plot(prf.(field{4}).Wakeup_State,'.')
            set(gca,'YTickLabel',(prf.(field{4}).Wakeup_States))
            title(warns{1})
            subplot(2,1,2), plot(prf.(field{4}).(sfield{4})),
            ylabel('BATTERY VOLTAGE')
        end
        for nn = 2:3% same check for Pitch and Roll
            if sum(prf.(field{4}).(sfield{3})(:,nn) == 1)/nns &gt; 0.05,
                warning(warns{nn})
                figure, subplot(2,1,1), plot(prf.(field{4}).(sfield{nn})(:,nn),'.')
                set(gca,'YTick',[0 1],'YTickLabel',{'Valid';'Out of Range'})
                title(warns{nn})
                subplot(2,1,2),plot(prf.(field{4}).(sfield{5+nn}))
                ylabel(sfield{5+nn})
            end
        end
        % check for unequal time-stepping:
        v = 86400 * diff(diff(prf.(field{4}).(sfield{1})));
        if any(abs(v) &gt; 0.001)
            warning('Profile intervals are not constant (unequal timing between profiles)')
            figure, plot(86400*diff(prf.(field{4}).(sfield{1})),'.'), ylabel('seconds')
        end
        % Determine cells above SSH:
        c = aqdCellPositions(prf.Hdr.(hfield{7}),prf.Hdr.(hfield{11}),prf.Hdr.(hfield{6}));
        cut = repmat(cosd(25)*prf.(field{4}).(sfield{9}),1,prf.Hdr.(hfield{6}))...
            &lt; repmat(c(:,3)',prf.Hdr.(hfield{1}),1);
        prf.ProfileMask = cut;
%         % Insert Nan's for measurements above SSH:
%         for n = [1:3 5:7]
%             prf.(field{n})(cut) = nan;
%         end
    end
    function errorCheckWaveHeader
        warns = {'Waveburst intervals are not constant (unequal timing between bursts)',...
            'Burst Counter is not sequential'};
        % check for unequal time-stepping:
        v = 86400 * diff(diff(prf.(field{8}).(wfield{1})));
        if any(abs(v) &gt; 0.001)
            warning(warns{1})
            figure, plot(86400*diff(prf.(field{8}).(wfield{1})),'.'), ylabel('seconds')
        end
        % check for missing bursts:
        v = diff(prf.(field{8}).(wfield{2}));
        if ~all(v), warning(warns{2}), figure, plot(v,'.'), title(warns{2}), end
    end
    function wav = errorCheckWaveBurst(wav)
        if nb == nburst &amp;&amp; length(wav{1}) ~= prf.(field{8}).(wfield{3}) % last sample was cut short
            warning(sprintf('Last wave burst contains only %g samples',length(wave{1})));
            % wav = []; prf.(field{8})(end) = []; return% so discard the last (partial) burst
        end
        % if the wave burst times weren't attached to the .WAD file, there
        % aren't any burst counters I can use to check continuous sampling
        % Of course, I would assume Nortek is checking these anyhow during
        % the ouput to ASCII format
        if N == 13
            warns = {'Wave burst counter error','Wave burst sample counter error',...
                };
            if any(wav{1} ~= prf.(field{8}).(wfield{2})(nb)), warning(warns{1}), end
            if any(wav{2} ~= [1:prf.(field{8}).(wfield{3})]'), warning(warns{2}), end
            wav(1:2) = [];
        end
        if N == 17, error('need to add error checking for wave burst format'), end
    end
end
