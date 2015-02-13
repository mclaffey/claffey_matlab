function vidz_feedback(vid, message)
% Display feedback if the parameter is set to do so

    if vid.params.feedback
        fprintf(message);
    end

end