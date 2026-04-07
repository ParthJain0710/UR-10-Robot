function [jointTrajectoryMsg] = JointVec2JointTrajectoryMsg(robot, q, t, qvel, qacc)
% Converts a sequence of joint configurations into a ROS JointTrajectory message
% q : (n x m) matrix of joint positions
% t : (n x 1) column vector of time stamps (seconds)
% qvel : (n x m) matrix of joint velocities
% qacc : (n x m) matrix of joint accelerations

% Set default velocities and accelerations if not provided
if nargin < 5
    qacc = zeros(size(q)); 
end
if nargin < 4
    qvel = zeros(size(q)); 
end

% Validate inputs
assert(size(q, 1) == length(t), '#Waypoints must match #time stamps.');
assert(size(qvel, 1) == length(t), '#Waypoint velocities must match #time stamps.');
assert(size(qacc, 1) == length(t), '#Waypoint accelerations must match #time stamps.');
expectedJoints = numel(homeConfiguration(robot));
assert(size(q, 2) == expectedJoints, 'Mismatch in joint dimension.');

% Initialize ROS message
jointTrajectoryMsg = rosmessage('trajectory_msgs/JointTrajectory');

% Assign joint names from robot configuration
jointConfig = homeConfiguration(robot);
for i = 1:length(jointConfig)
    jointTrajectoryMsg.JointNames{i} = jointConfig(i).JointName;
end

% Assign trajectory points
for i = 1:size(q, 1)
    pointMsg = rosmessage('trajectory_msgs/JointTrajectoryPoint');
    pointMsg.Positions = q(i, :);
    pointMsg.Velocities = qvel(i, :);
    pointMsg.Accelerations = qacc(i, :);
    pointMsg.TimeFromStart = rosduration(t(i));
    jointTrajectoryMsg.Points = [jointTrajectoryMsg.Points; pointMsg];
end

% Set timestamp
jointTrajectoryMsg.Header.Stamp = rostime('now');

end
