

% Create a subscriber for /joint_states using a callback
jointStateSub = rossubscriber('/joint_states', 'sensor_msgs/JointState', @jointStateCallback);

% Allow time for messages to be received
pause(5);

% Callback function to process incoming joint states
function jointStateCallback(~, msg)
    jointPositions = msg.Position(1:6);
    disp('Current Joint Positions:');
    disp(jointPositions);
end