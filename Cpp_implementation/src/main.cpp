#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <ctime>

#include <opencv2/imgproc/imgproc.hpp>
#include "optEyePose.h"


int main()
{
    std::clock_t start;
    double duration;

    double focal = 785.61928174049433;
    long timestampe;
    SGDOptimizer EyeOptmizer( focal );
    cv::Point leftEye, rightEye;

    std::vector<cv::Point> vOptLeftEyePosition, vOptRightEyePosition;

    std::ifstream file("/home/zhantao/Documents/Datasets/abs_pupil_pose_rect.txt");

    start = std::clock();

    if (file.is_open()) {
        std::string line;
        while (getline(file, line)) {
            string data;
            stringstream ss(line);

            getline(ss, data, ',');
            timestampe = std::atol(data.c_str());
            getline(ss, data, ',');
            leftEye.x = std::atoi(data.c_str());
            getline(ss, data, ',');
            leftEye.y = std::atoi(data.c_str());
            getline(ss, data, ',');
            rightEye.x = std::atoi(data.c_str());
            getline(ss, data, ',');
            rightEye.y = std::atoi(data.c_str());


            EyeOptmizer.receiver(leftEye, rightEye);

            if (EyeOptmizer.initiated){
                vOptLeftEyePosition.push_back ( cv::Point(EyeOptmizer.voptleftx(iInitialFrames - 1),  EyeOptmizer.voptlefty(iInitialFrames - 1) ));
                vOptRightEyePosition.push_back( cv::Point(EyeOptmizer.voptrightx(iInitialFrames - 1), EyeOptmizer.voptrighty(iInitialFrames - 1) ));
            }
        }
        file.close();
    }
    else{
        std::cout << "Can not open the file in" << std::endl;
        exit(-1);
    }

    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    std::cout<<"Duration is: "<< duration <<endl;


    std::ofstream ofs;
    ofs.open ("pupil_pose.txt", std::ofstream::out | std::ofstream::app);
    for(int ct = 0; ct < vOptLeftEyePosition.size(); ct++){
        ofs << 0 << ',' << vOptLeftEyePosition[ct].x << ',' <<  vOptLeftEyePosition[ct].y << ',' << vOptRightEyePosition[ct].x  << ',' << vOptRightEyePosition[ct].y << std::endl;
    }
    ofs.close();

    return 0;
}
