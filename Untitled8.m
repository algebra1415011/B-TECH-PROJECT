%create filters
differenceFilter = Difference( );
IFilter thresholdFilter = new Threshold( 15 );
%set backgroud frame as an overlay for difference filter
differenceFilter.OverlayImage = backgroundFrame;
%apply the filters
Bitmap tmp1 = differenceFilter.Apply( currentFrame );
Bitmap tmp2 = thresholdFilter.Apply( tmp1 );
%create filter
IFilter erosionFilter = new Erosion( );
%apply the filter 
Bitmap tmp3 = erosionFilter.Apply( tmp2 );