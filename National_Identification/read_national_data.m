movmeanK=3;

%% Load and read the data form GitHub

%%Uncomment if you never loaded the data
% fid=fopen('data_national.txt','wt');
% fprintf(fid,webread('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv')); 
% fclose(fid); 
%Read the data saved on a txt file
data=readtable('data_national.txt');

%% Sort and filter data
total_positive= movmean(data.totale_positivi',movmeanK);
total_rec = movmean(data.dimessi_guariti',movmeanK);
total_dead   = movmean(data.deceduti',movmeanK);
total_hosp     = movmean(data.totale_ospedalizzati',movmeanK);
total_quar     = movmean(data.isolamento_domiciliare',movmeanK);
tab_data       =[total_positive+total_rec+total_dead];
N=60e6;
total_active  = N-total_quar-total_hosp-total_dead;
Namer='Nation';