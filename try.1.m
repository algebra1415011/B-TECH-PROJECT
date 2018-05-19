if    error('Usage: [y,fs,wmode,fidx]=READWAV(filename,mode,nmax,nskip)'); end
0097 if nargin<2
0098     mode='p';
0099 else
0100     mode = [mode(:).' 'p'];
0101 end
0102 k=find((mode>='p') & (mode<='s'));
0103 mno=all(mode~='o');                      % scale to input limits not output limits
0104 sc=mode(k(1));
0105 z=128*all(mode~='z');
0106 info=zeros(1,11);
0107 if ischar(filename)
0108     if any(mode=='d')
0109         filename=fullfile(voicebox('dir_data'),filename);
0110     end
0111     fid=fopen(filename,'rb','l');
0112     if fid == -1
0113         fn=[filename,'.wav'];
0114         fid=fopen(fn,'rb','l');
0115         if fid ~= -1
0116             filename=fn;
0117         end
0118     end
0119     if fid == -1
0120         error('Can''t open %s for input',filename);
0121     end
0122     info(1)=fid;
0123 else
0124     info=filename;
0125     fid=info(1);
0126 end
0127 getdat= nargout>0 || any(lower(mode)=='w') || any(lower(mode)=='a');
0128 mh=any(mode=='h') || ~getdat;
0129 if ~info(3)
0130     fseek(fid,8,-1);                        % read riff chunk
0131     header=fread(fid,4,'*char')';
0132     if ~strcmp(header,'WAVE')
0133         fclose(fid);
0134         error('File does not begin with a WAVE chunck');
0135     end
0136     if mh
0137         fprintf('\nWAVE file: %s\n',filename);
0138     end
0139     fmtlen=-1;
0140     datalen=-1;
0141     instlen=-1;
0142     factlen=-1;
0143     riffmt='e';  % default is original wave file format
0144     while datalen<0                        % loop until FMT and DATA chuncks both found
0145         header=fread(fid,4,'*char');
0146         len=fread(fid,1,'ulong');
0147         if mh
0148             fprintf('  %s chunk: %d bytes\n',header,len);
0149         end
0150         if strcmp(header','fmt ')                    % ******* found FMT chunk *********
0151             fmtlen=len;                             % remember the length
0152             if len>16
0153                 riffmt='x';  % might be WAVEFORMATEX format
0154             end
0155             wavfmt=fread(fid,1,'short');            % format: 1=PCM, 6=A-law, 7-Mu-law
0156             info(8)=wavfmt;
0157             info(5)=fread(fid,1,'ushort');            % number of channels
0158             fs=fread(fid,1,'ulong');                % sample rate in Hz
0159             info(9)=fs;                             % sample rate in Hz
0160             rate=fread(fid,1,'ulong');                % average bytes per second (ignore)
0161             align=fread(fid,1,'ushort');            % block alignment in bytes (container size * #channels)
0162             bps=fread(fid,1,'ushort');            % bits per sample
0163             info(7)=bps;
0164             %             info(6)=ceil(info(7)/8);                % round up to a byte count
0165             info(6)=floor(align/info(5));                       % assume block size/channels = container size
0166             if info(8)==-2   % wave format extensible
0167                 cb=fread(fid,1,'ushort');            % extra bytes must be >=22
0168                 riffmt='X';                         % WAVEFORMATEXTENSIBLE format
0169                 wfxsamp=fread(fid,1,'ushort');            % samples union
0170                 if wfxsamp>0
0171                     info(7)=wfxsamp;     % valid bits per sample
0172                 end
0173                 info(10)=fread(fid,1,'ulong');                % channel mask
0174                 wfxguida=fread(fid,1,'ulong');                % GUID
0175                 wfxguidb=fread(fid,2,'ushort');                % GUID
0176                 wfxguidc=fread(fid,8,'uchar');                % GUID
0177                 if wfxguida<65536
0178                     info(8)=wfxguida; % turn it into normal wav format
0179                 end
0180                 fseek(fid,len-40,0);                    % skip to end of header
0181             else
0182                 if align>0 && align<(info(6)+4)*info(5)
0183                     info(6)=ceil(align/info(5));
0184                 end
0185                 fseek(fid,len-16,0);                    % skip to end of header
0186             end
0187             if mh
0188                 fmttypes={'?' 'PCM' 'ADPCM' 'IEEE-float' '?' '?' 'A-law' 'µ-law' '?'};
0189                 fprintf('        Format: %d = %s',info(8),fmttypes{1+max(min(info(8),8),0)});
0190                 if wavfmt==-2
0191                     fprintf(' (%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x)\n',wfxguida,wfxguidb,wfxguidc);
0192                 else
0193                     fprintf('\n');
0194                 end
0195                 fprintf('        %d channels at %g kHz sample rate (%d kbytes/s)\n',info(5),fs/1000,rate/1000);
0196                 fprintf('        Mask=%x:',info(10));
0197                 spkpos={'FL' 'FR' 'FC' 'W' 'BL' 'BR' 'FLC' 'FRC' 'BC' 'SL' 'SR' 'TC' 'TFL' 'TFC' 'TFR' 'TBL' 'TBC' 'TBR'};
0198                 for i=1:18
0199                     if mod(floor(info(10)*pow2(1-i)),2)
0200                         fprintf([' ' spkpos{i}]);
0201                     end
0202                 end
0203                 fprintf('\n        %d valid bits of %d per sample (%d byte block size)\n',info(7),bps,align);
0204             end
0205         elseif strcmp(header','fact')                % ******* found FACT chunk *********
0206             factlen=len;
0207             if len<4
0208                 error('FACT chunk too short');
0209             end
0210             nsamp=fread(fid,1,'ulong');                % number of samples
0211             fseek(fid,len-4,0);                     % skip to end of header
0212             if mh
0213                 fprintf('        %d samples = %.3g seconds\n',nsamp,nsamp/fs);
0214             end
0215         elseif strcmp(header','inst')                % ******* found INST chunk *********
0216             instlen=len;
0217             if len<7
0218                 error('INST chunk too short');
0219             end
0220             inst=fread(fid,3,'schar');
0221             info(11)=double(inst(3));                          % gain in dB
0222             if mh
0223                 fprintf('        Gain = %d dB\n',info(11));
0224             end
0225             fseek(fid,len-3,0);                     % skip to end of header
0226         elseif strcmp(header','data')                % ******* found DATA chunk *********
0227             if fmtlen<0
0228                 fclose(fid);
0229                 error('File %s does not contain a FMT chunck',filename);
0230             end
0231             if factlen>3 && nsamp >0
0232                 info(4)=nsamp;   % take data length from FACT chunk
0233             else
0234                 info(4) = fix(len/(info(6)*info(5)));  % number of samples
0235             end
0236             info(3)=ftell(fid);                    % start of data
0237             datalen=len;
0238             if mh
0239                 fprintf('        %d samples x %d channels x %d bytes/samp',info(4:6));
0240                 if prod(info(4:6))~=len
0241                     fprintf(' + %d padding bytes',len-prod(info(4:6)));
0242                 end
0243                 fprintf(' = %g sec\n',info(4)/fs);
0244             end
0245         else                            % ******* found unwanted chunk *********
0246             fseek(fid,len,0);
0247         end
0248     end
0249 else
0250     fs=info(9);
0251 end
0252 if nargin<4 || nskip<0
0253     nskip=info(2);  % resume at current file position
0254 end
0255 
0256 ksamples=info(4)-nskip; % number of samples remaining
0257 if nargin>2
0258     if nmax>=0
0259         ksamples=min(nmax,ksamples);
0260     end
0261 elseif ~getdat
0262     ksamples=min(5,ksamples); % just read 5 samples so we can print the first few data values
0263 end
0264 if ksamples>0
0265     info(2)=nskip+ksamples;
0266     fseek(fid,info(3)+info(6)*info(5)*nskip,-1);
0267     nsamples=info(5)*ksamples;
0268     if any(info(8)==3)  % floating point format
0269         pk=1;  % peak is 1
0270         switch info(6)
0271             case 4
0272                 y=fread(fid,nsamples,'float32');
0273             case 8
0274                 y=fread(fid,nsamples,'float64');
0275             otherwise
0276                 error('cannot read %d-byte floating point numbers',info(6));
0277         end
0278     else
0279         if ~any(info(8)==[1 6 7])
0280             sc='r';  % read strange formats in raw integer mode
0281         end
0282         pk=pow2(0.5,8*info(6))*(1+(mno/2-all(mode~='n'))/pow2(0.5,info(7)));  % use modes o and n to determine effective peak
0283         switch info(6)
0284             case 1
0285                 y=fread(fid,nsamples,'uchar');
0286                 if info(8)==1
0287                     y=y-z;
0288                 elseif info(8)==6
0289                     y=pcma2lin(y,213,1);
0290                     pk=4032+mno*64;
0291                 elseif info(8)==7
0292                     y=pcmu2lin(y,1);
0293                     pk=8031+mno*128;
0294                 end
0295             case 2
0296                 y=fread(fid,nsamples,'short');
0297             case 3
0298                 y=fread(fid,3*nsamples,'uchar');
0299                 y=reshape(y,3,nsamples);
0300                 y=([1 256 65536]*y-pow2(fix(pow2(y(3,:),-7)),24)).';
0301             case 4
0302                 y=fread(fid,nsamples,'long');
0303             otherwise
0304                 error('cannot read %d-byte integers',info(6));
0305         end
0306     end
0307     if sc ~= 'r'
0308         if sc=='s'
0309             sf=1/max(abs(y(:)));
0310         elseif sc=='p'
0311             sf=1/pk;
0312         else
0313             if info(8)==7
0314                 sf=2.03761563/pk;
0315             else
0316                 sf=2.03033976/pk;
0317             end
0318         end
0319         y=sf*y;
0320     else                             % mode = 'r' - output raw values
0321         if info(8)==1
0322             y=y*pow2(1,info(7)-8*info(6));  % shift to get the bits correct
0323         end
0324     end
0325     if any(mode=='g') && info(11)~=0
0326         y=y*10^(info(11)/20);   % scale by the gain
0327     end
0328     if info(5)>1
0329         y = reshape(y,info(5),ksamples).';
0330     end
0331 else
0332     y=[];
0333 end
0334 if all(mode~='f')
0335     fclose(fid);
0336 end
0337 if nargout>2  % sort out the mode input for writing this format
0338     wmode=char([riffmt sc 'z'-z/128]);
0339     if factlen>0
0340         wmode=[wmode 'E'];
0341     end
0342     if info(6)>1 && info(6)<5
0343         cszc=' cCL';
0344         wmode=[wmode cszc(info(6))];
0345     end
0346     switch info(8)
0347         case 1                                    % PCM modes
0348             if ~mno
0349                 wmode=[wmode 'o'];
0350             end
0351             if any(mode=='n')
0352                 wmode=[wmode 'n'];
0353             end
0354             wmode=[wmode num2str(info(7))];
0355         case 3
0356             if info(7)<=32
0357                 wmode = [wmode 'v'];
0358             else
0359                 wmode = [wmode 'V'];
0360             end
0361         case 6
0362             wmode = [wmode 'a'];
0363         case 7
0364             wmode = [wmode 'u'];
0365     end
0366     fidx=info;
0367 end
0368 [ns,nchan]=size(y);
0369 if mh && ns>0
0370     nsh=min(ns,5);  % print first few samples
0371     for i=1:nsh
0372         fprintf('        %d:',i);
0373         fprintf(' %.3g',y(i,:));
0374         fprintf('\n');
0375     end
0376 end
0377 
0378 if ns>0.01*fs
0379     if any(lower(mode)=='a')
0380         nsh=min(ns,10*fs+ns*any(mode=='A'));
0381         soundsc(y(1:nsh,1:min(nchan,2)),fs);
0382     end
0383     if any(mode=='W')
0384         spm='pJcbf ';
0385         if any(mode=='w')
0386             spm(end)='w';
0387         end
0388         clf;
0389         if nchan>1
0390             for i=nchan:-1:1
0391                 subplot(nchan,1,i)
0392                 spgrambw(y(:,i),fs,spm);
0393             end
0394         else
0395             spgrambw(y,fs,spm);
0396         end
0397     elseif any(mode=='w')
0398         clf;
0399         if nchan>1
0400             for i=nchan:-1:1
0401                 subplot(nchan,1,i)
0402                 plot((1:ns)/fs,y(:,i));
0403                 ylabel(['Chan ' num2str(i)]);
0404                 if i==nchan
0405                     xlabel('Time (s)');
0406                 end
0407             end
0408         else
0409             plot((1:ns)/fs,y);
0410             xlabel('Time (s)');
0411         end
0412 
0413     end
0414 end