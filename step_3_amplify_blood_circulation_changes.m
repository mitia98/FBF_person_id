clear all
close all
clc

% Step 
% This code applies spatial Gdown temporal function in order to amplify the
% color changes that blood circulation create on the face, so to make it
% visible.

% Define video paths
%video_path = 'Datasets\June2019\Cropped_Videos\';
%video_path = 'Datasets\June2019\Three_Videos_Out\Attenuated_Videos\Forehead\';
% video_path = 'E:\�������\facial_blood_flow_recognition\Codes\Datasets\Three_Videos_Out\Attenuated_Videos\Forehead\';
% video_path = 'E:\�������\facial_blood_flow_recognition\Codes\Datasets\Three_Videos_Out\Attenuated_Videos\Right_Cheek\';
% video_path = 'E:\�������\facial_blood_flow_recognition\Codes\Datasets\Three_Videos_Out\Attenuated_Videos\Left_Cheek\';
% video_path = 'E:\Codes\facial_blood_flow_recognition\Codes\Datasets\DetsikasN\Attenuated_Videos\Right_Cheek\';
% video_path = 'E:\Codes\facial_blood_flow_recognition\Codes\Datasets\DetsikasN\Attenuated_Videos\Left_Cheek\';
video_path = 'E:\Codes\facial_blood_flow_recognition\Codes\Datasets\DetsikasN\Attenuated_Videos\Forehead\';

%subfolders = dir(video_path);
day_subfolders = ['Day1\'; 'Day2\'; 'Day3\'];
day_len = size(day_subfolders, 1);
person_subfolders = ['01\';'02\';'03\';'04\';'05\';'06\';'07\';'08\';'09\';'10\';'11\';'12\';'13\'];
person_len = size(person_subfolders, 1);

% Define out video path
%out_video_path = 'Datasets\June2019\Amplified_Blood_Flow_Without_Attenuation\';
% out_video_path = 'Datasets\June2019\Three_Videos_Out\Amplified_Blood_Flow_After_Attenuation\Forehead\';
%out_video_path = 'Datasets\June2019\Three_Videos_Out\Amplified_Only_Blood_Flow_After_Attenuation\Forehead\';
% out_video_path = 'E:\�������\facial_blood_flow_recognition\Codes\Datasets\Three_Videos_Out\Amplified_Blood_Flow_After_Attenuation\Forehead\';
% out_video_path = 'E:\�������\facial_blood_flow_recognition\Codes\Datasets\Three_Videos_Out\Amplified_Blood_Flow_After_Attenuation\Right_Cheek\';
% out_video_path = 'E:\�������\facial_blood_flow_recognition\Codes\Datasets\Three_Videos_Out\Amplified_Blood_Flow_After_Attenuation\Left_Cheek\';
% out_video_path = 'E:\Codes\facial_blood_flow_recognition\Codes\Datasets\DetsikasN\Amplified_Blood_Flow\Right_Cheek\';
% out_video_path = 'E:\Codes\facial_blood_flow_recognition\Codes\Datasets\DetsikasN\Amplified_Blood_Flow\Left_Cheek\';
out_video_path = 'E:\Codes\facial_blood_flow_recognition\Codes\Datasets\DetsikasN\Amplified_Blood_Flow\Forehead\';


alpha = 120;
level = 4;
fl = 0.83;
fh = 1;
samplingRate = 30;
chromAttenuation = 1;

% For every day 
for i=1:day_len
    
    % For every person
    for j=1:person_len
        
        % Define video path
        vpath = [video_path day_subfolders(i, :) person_subfolders(j, :)];
        files = dir(vpath);
       
        % For every video in vpath
        for k=3:length(files)
            
            % Load video
            vfilename = [vpath files(k).name];
%             v = VideoReader(vfilename);
            
            % Construct video writer
            [fpath, name, ext] = fileparts(files(k).name);
            out_vfilename = [out_video_path day_subfolders(i, :) person_subfolders(j, :)] 
%             vwriter = VideoWriter(out_vfilename, 'Uncompressed AVI');
%             open(vwriter);
            
            tic
            
            amplify_spatial_Gdown_temporal_ideal_Only_Amplification(vfilename,out_vfilename,alpha,level, ...
                     fl,fh,samplingRate, chromAttenuation);
            
            toc
            
        end
    end
end