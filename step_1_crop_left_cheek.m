clear all
close all
clc

% Step1:
% This code detects the face (bounding box) at the 1st video frame and crops
% the frame in order to keep only the info needed (the face) using the
% coordinates of extracted bounding box

% Set directory


addpath(genpath('E:\�������\facial_blood_flow_recognition\Codes\face-release1.0-basic'));
addpath(genpath('E:\�������\facial_blood_flow_recognition\Codes'));
% Load model for face detection
load face_p99.mat; % model

% Load AAM model
load cGN_DPM.mat;

% Set directory
cd 'E:\�������\facial_blood_flow_recognition\Codes';

% Define video paths
video_path = 'Datasets\Original_Videos\';
%subfolders = dir(video_path);
day_subfolders = ['Day1\'; 'Day2\'; 'Day3\'];
day_len = size(day_subfolders, 1);
person_subfolders = ['01\';'02\';'03\';'04\';'05\';'06\';'07\';'08\';'09\';'10\';'11\';'12\';'13\'];
person_len = size(person_subfolders, 1);

% Define out video path
out_video_path = 'Datasets\Three_Videos_Out\Original\';

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
            v = VideoReader(vfilename);
            
            % Construct video writer
            [fpath, name, ext] = fileparts(files(k).name);
            
            % Forehead
            out_vfilename = [out_video_path 'Right_Cheek\' day_subfolders(i, :) person_subfolders(j, :) name] 
            vwriter = VideoWriter(out_vfilename, 'Uncompressed AVI');
            open(vwriter);
            
            tic
            
            % Extract 1st frame
            frame = readFrame(v);

            % rect: bbox of detected face
            [fitbox, rect] = detect_face(frame, model, 512, 512);  % 512 x 512 output frame
            
            % Fitting AAM
            iter = 5;
            fitted_shape=GN_DPM_fit(frame, fitbox, cGN_DPM, iter);      
            
            % Find right cheeck
            
            
            % Sort fitted_shape / column
            fitted_shape_x_sorted = sort(fitted_shape(:, 1), 'ascend');
%             fitted_shape_y_sorted = sort(fitted_shape(:, 2), 'ascend');
            
            min_x = fitted_shape_x_sorted(1);
            max_x = fitted_shape_x_sorted(length(fitted_shape_x_sorted));
            
%             % Find center of face
%             center = (max_x - min_x)/2;
%             threshold = min_x + center;
            
            % Find eye brows rightest points
            [p1_x p1_y] = find(fitted_shape(:, 1) == fitted_shape_x_sorted(1));   
            
%             k = 2;         
%             [p2_x p2_y] = find(fitted_shape(:, 2) == fitted_shape_y_sorted(k));
%             
%              while(fitted_shape(p2_x, 1) <= threshold)
%                  k = k + 1;
%                  [p2_x p2_y] = find(fitted_shape(:, 2) == fitted_shape_y_sorted(k));
%              end
                                    
            % Find right cheeck            
            rcheeck_h = 70;
            rcheeck_w = 100;
            
            % Create forehead rectangle
            move_down = 120
            rcheeck_rect = [fitted_shape_x_sorted(1), fitted_shape(p1_x, 2)+move_down-rcheeck_h, rcheeck_w, rcheeck_h];
            
            % For every frame
            while hasFrame(v)
                
                % Cropped face 
                cropped_frame = imcrop(frame, rcheeck_rect);
                
                % Write cropped frame in new video
                writeVideo(vwriter, cropped_frame);
                
                % Read new frame
                frame = readFrame(v);
            end
            
            close(vwriter);
            toc
            
        end
    end
end
    


