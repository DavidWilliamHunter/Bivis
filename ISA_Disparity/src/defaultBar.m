plotDirectory = '..\src\plots\2\';
gaborDirectory = '../data/2/';

nbootstraps = 100;

subspacesize = 2;


modelTypeProto = {'Squared_%s','AbsMaxPooled_%s','SquaredHalfRec_%s','MaxPooledHalfRec_%s', 'SquaredFullRec_%s','MaxPooledExhMaxPooledInhib_%s','SimpleSum_%s','MaxPooledUnRectified_%s'};
modelTypeStub = {'Squared','AbsMaxPooled','SquaredHalfRec','MaxPooledHalfRec', 'SquaredFullRec','MaxPooledExhMaxPooledInhib','SimpleSum','MaxPooledUnRectified'};



stimuliTypeNames = {'gratings','bars'};
simpleStimuliTypeNames = {'GratingsSingle','BarsSingle'};

name = { 'lowest', '2nd', '3rd', 'highest' };
lbounds = [ 0 1./(1+3) 1./(1+1) 1./(1+0.5)];
ubounds = [ 1./(1+3) 1./(1+1) 1./(1+0.5) 1 ];

exemplarModels = 1:9;