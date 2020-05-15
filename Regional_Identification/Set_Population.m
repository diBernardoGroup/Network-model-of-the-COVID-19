function [N,Namer] = Set_Population(region_code)

switch region_code
        case 1
            N=4.356e6;
            Namer='piedmont';
        case 2
            N=125666;
            Namer='aosta';
        case 4
            N=538223;
            Namer='trentino';
        case 5
            N=4.906e6;
            Namer='veneto';
        case 6
            N=1.215e6;
            Namer='friuli';
        case 7
            N=1.551e6;
            Namer='liguria';
        case 9
            N=3.73e6;
            Namer='tuscany';
        case 10
            N=882015;
            Namer='umbria';
        case 11
            N=1.525e6;
            Namer='marche';
        case 12
            N=5.879e6;
            Namer='lazio';
        case 13
            N=1.312e6;
            Namer='abruzzo';
        case 14
            N=305617;
            Namer='molise';
        case 15
            N=5.802e6;
            Namer='campania';
        case 16
            N=4.029e6;
            Namer='apulia';
        case 17
            N=562869;
            Namer='basilicata';
        case 18
            N=1.947e6;
            Namer='calabria';
        case 19
            N=5e6;
            Namer='sicily';
        case 20
            N=1.64e6;
            Namer='sardinia';
        case 8
            N=4.459e6;
            Namer='emilia';
        case 3
            N=10.6e6;
            Namer='lombardy';
end


end

