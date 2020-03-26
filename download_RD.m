function download_RD(address,login,passw,ftpdir,fclue,tardir,ext)
ftpobj = ftp(address,login,passw);
dir(ftpobj)
cd(ftpobj,ftpdir)
dir(ftpobj)
files=dir(ftpobj,fclue);
for i=1:numel(files)
    disp(['Downloading file number ' num2str(i)])
    tic
    mget(ftpobj,files(i).name,tardir)
    if ext==1
        disp('... extracting data ...')
        gunzip([tardir files(i).name])
        untar([tardir files(i).name(1:end-3)],tardir)
        delete([tardir files(i).name(1:end-3)])
    end
end
toc

close(ftpobj)

