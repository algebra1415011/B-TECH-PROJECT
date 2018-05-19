readerobj = mmreader('test.avi');%, 'tag', 'myreader1');
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');
 for k = 1 : numFrames
    mov(k).cdata = vidFrames(:,:,:,k);
   mov(k).colormap = [];
   %figure,imshow(k);
end
hf = figure;
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
movie(hf, mov, 1, readerobj.FrameRate);