package com.mapps.pulsedata;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import com.google.common.base.Optional;
import com.google.gson.Gson;

/**
 *
 *
 */
public class RestPulseForAge {
    private List<Integer> malePulse;
    private List<Integer> femalePulse;

    private static Optional<RestPulseForAge> instance;

    public RestPulseForAge() {

    }

    public static RestPulseForAge getDefault() throws IOException {
        if (instance.isPresent()) {
            return instance.get();
        }
        instance = Optional.of(loadFromJson());
        return instance.get();
    }

    public static RestPulseForAge loadFromJson() {
        try {
            InputStream stream =  RestPulseForAge.class.getClassLoader().getResourceAsStream("pulseagedata/pulseagedata");
            BufferedReader br = new BufferedReader(new InputStreamReader(stream));
            String json = br.readLine();
            return new Gson().fromJson(json, RestPulseForAge.class);
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public List<Integer> getMalePulse() {
        return malePulse;
    }

    public List<Integer> getFemalePulse() {
        return femalePulse;
    }
}
