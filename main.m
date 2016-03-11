
addpath Dataset/
%I = imread('lenna.jpg');
%I = imread('elaine_512.gif');
% I = imread('cameraman.png');
% I = imread('couple.png');
I = imread('man.tif');
I2 = im2double(I);
[M,N] = size(I2);

%k =16;
t1 = [];
s1 = [];
r1 = [];

CR_dct = [];
CR_fwht = [];
CR_zipper = [];

avlen_dct = [];
avlen_fwht = [];
avlen_zipper = [];

entropy_dct = [];
entropy_fwht = [];
entropy_zipper = [];

%block_size1 = 1:50;
block_size1 = [4 8 16 32 64 128];

for block_size =block_size1;
    
 %%%%%%%%%%%%%%%%%%%%%Discrete Cosine Transform%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tic,
 dctx = @(block_struct) dct2(block_struct.data);
 B = blockproc(I2,[block_size,block_size],dctx);
 a= min(min(B));
 b= max(max(B));
 ent_B = entropy(B);
 C = mat2gray(B);
 C = uint8(max(max(double(I)))*C);
 
 %% Huffman Coding for DCT
     %Encoding
        [count,sym] = (imhist(C));
        p = count / sum(count);  
        [dict,avglen]=huffmandict(sym,p); % build the Huffman dictionary
        comp= huffmanenco(C(:),dict);
     % Decoding
         deco= huffmandeco(comp, dict);
         C_deco = reshape(deco,M,N);
         C_deco = uint8(C_deco);
         C_deco = im2double(C_deco);
         B_deco = normalize_var(C_deco, a, b);
  
 %%%% Inverse Discrete Cosine Transform
idctx = @(block_struct) idct2(block_struct.data);
I2_dct_hat = blockproc(B_deco,[block_size,block_size],idctx);
t = toc;

%%%%%%%%%%%%%%%%%%%%Fast Walsh-Hadamard transform%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tic,
 fwht1 = @(block_struct) HAD2(block_struct.data);
 B1 = blockproc(I2,[block_size,block_size],fwht1);
 a1= min(min(B1));
 b1= max(max(B1));
 ent_B1 = entropy(B1);
 C1 = mat2gray(B1);
 C1 = uint8(max(max(double(I)))*C1);
 
 % Huffman Coding for FWHT
     %Encoding
        [count1,sym1] = (imhist(C1));
        p1 = count1 / sum(count1);  
        [dict1,avglen1]=huffmandict(sym1,p1); % build the Huffman dictionary
        comp1= huffmanenco(C1(:),dict1);
    % Decoding
         deco1= huffmandeco(comp1, dict1);
         C1_deco = reshape(deco1,M,N);
         C1_deco = uint8(C1_deco);
         C1_deco = im2double(C1_deco);
         B1_deco = normalize_var(C1_deco, a1, b1);
  
ifwht1 = @(block_struct) iHAD2(block_struct.data);
I2_fwht_hat = blockproc(B1_deco,[block_size,block_size],ifwht1);
s = toc;

%%%%%%%%%%%%%%%%%%%%%Zipper transform%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tic,
 z = @(block_struct) zipper2(block_struct.data);
 B2 = blockproc(I2,[block_size,block_size],z);
 a2= min(min(B2));
 b2= max(max(B2));
 ent_B2 = entropy(B2);
 C2 = mat2gray(B2);
 C2 = uint8(max(max(double(I)))*C2);
 
 %% Huffman Coding for Zipper Transform
     %Encoding
        [count2,sym2] = (imhist(C2));
        p2 = count2 / sum(count2);  
        [dict2,avglen2]=huffmandict(sym2,p2); % build the Huffman dictionary
        comp2= huffmanenco(C2(:),dict2);
     % Decoding
         deco2= huffmandeco(comp2, dict2);
         C2_deco = reshape(deco2,M,N);
         C2_deco = uint8(C2_deco);
         C2_deco = im2double(C2_deco);
         B2_deco = normalize_var(C2_deco, a2, b2);
  
iz = @(block_struct) izipper(block_struct.data);
I2_zipper_hat = blockproc(B2_deco,[block_size,block_size],iz);
r = toc;
% 
% %%%%%%%%%%%%%%%%%%Compression Ratio%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ent_A = entropy(I2);

% comp_ratio = ent_A/ent_B;
% comp_ratio1 = ent_A/ent_B1;
% comp_ratio2 = ent_A/ent_B2;

comp_ratio = 8/avglen;
comp_ratio1 = 8/avglen1;
comp_ratio2 = 8/avglen2;
 
CR_dct = [CR_dct comp_ratio];
CR_fwht = [CR_fwht comp_ratio1];
CR_zipper = [CR_zipper comp_ratio2];

avlen_dct = [avlen_dct avglen];
avlen_fwht = [avlen_fwht avglen1];
avlen_zipper = [avlen_zipper avglen2];

entropy_dct = [entropy_dct ent_B];
entropy_fwht = [entropy_fwht ent_B1];
entropy_zipper = [entropy_zipper ent_B2];
% %%%%%%%%%%%%% Running Time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
t1 = [t1 t];
s1 = [s1 s];
r1 = [r1 r];
 end

%%%%%%%%%%%%%%%%%%%PLOTTING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
plot(block_size1,CR_dct,'-p',block_size1,CR_fwht,'-v',block_size1,CR_zipper,'-d')
xlabel('Block size') 
ylabel('Compression Ratio (CR)')
legend('DCT','FWHT','ZT')

figure(2)
plot(block_size1,t1,'-p',block_size1,s1,'-v',block_size1,r1,'-d')
xlabel('Block size') 
ylabel('Running Time (Seconds)')
legend('DCT','FWHT','ZT')
