function [N,Namer] = Set_Population(region_code)

switch region_code
        case 1
            N=4.356e6;
            Namer='Piedmont';
        case 2
            N=125666;
            Namer='Aosta Valley';
        case 4
            N=538223;
            Namer='Trentino';
        case 5
            N=4.906e6;
            Namer='Veneto';
        case 6
            N=1.215e6;
            Namer='Friuli';
        case 7
            N=1.551e6;
            Namer='Liguria';
        case 9
            N=3.73e6;
            Namer='Tuscany';
        case 10
            N=882015;
            Namer='Umbria';
        case 11
            N=1.525e6;
            Namer='Marche';
        case 12
            N=5.879e6;
            Namer='Lazio';
        case 13
            N=1.312e6;
            Namer='Abruzzo';
        case 14
            N=305617;
            Namer='Molise';
        case 15
            N=5.802e6;
            Namer='Campania';
        case 16
            N=4.029e6;
            Namer='Apulia';
        case 17
            N=562869;
            Namer='Basilicata';
        case 18
            N=1.947e6;
            Namer='Calabria';
        case 19
            N=5e6;
            Namer='Sicily';
        case 20
            N=1.64e6;
            Namer='Sardinia';
        case 8
            N=4.459e6;
            Namer='Emilia';
        case 3
            N=10.6e6;
            Namer='Lombardy';
end


end

