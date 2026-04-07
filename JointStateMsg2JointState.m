function [jointState, jointVel] = JointStateMsg2JointState(jointMsg)
    % Ensure input is valid
    if isempty(jointMsg.Position) || isempty(jointMsg.Velocity)
        error('Received an empty JointState message!');
    end

    % Extract the number of joints
    numJoints = min(length(jointMsg.Position), 6);  % Ensure only first 6 joints

    % Extract Joint Positions and Velocities
    jointState = jointMsg.Position(1:numJoints);
    jointVel = jointMsg.Velocity(1:numJoints);
end
