package com.mapps.utils;


import com.google.common.base.Function;

/**
 *
 *
 */
public interface Bijection<F, T> extends Function<F, T> {
    /**
     * Provides the inverse function of this bijection.
     *
     * @since 1.8
     * @return a bijection which defines the inversion of this bijection
     */
    Bijection<T, F> inverse();
}
