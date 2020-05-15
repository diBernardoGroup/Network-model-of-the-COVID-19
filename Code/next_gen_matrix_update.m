function [mu_1_K,mu_2_K,mu_inf_K,R_0,R_0_connected,K_r,K_c] = next_gen_matrix_update(M,N,N_p,Phi,rho,beta,alpha,gamma,psi)
    K = zeros(M);
    K_r = zeros(M);
    K_c = zeros(M);
    R_0_connected = zeros(M,1);
    
    for m  = 1 : M
        for n = 1 : M 
            K(m, n) = N(m) * sum(rho(:) .* beta .* Phi(m,:)'...
                            .* Phi(n,:)' ./ N_p); 
        end
    end
    K(:, :) = (diag(alpha + gamma + psi)) \ K(:, :);
    mu_1_K = max(sum(K(:, :), 1));
    mu_2_K = max(eig((K(:, :) + K(:, :)') / 2));
    mu_inf_K = max(sum(K(:, :), 2));
    R_0 = max(abs(eig(K(:, :))));

    R_0_connected(:) = diag(K(:, :));

    for i = 1 : M
        for j = 1 : M
            K_r(i, j) = rho(j) * beta(j) * Phi(i, j)...
                        * N(i) / N_p(j) * sum(Phi(:, j));
        end
    end
    K_r(:, :) = (diag(alpha + gamma + psi)) \ K_r(:, :);

    for j = 1 : M
        for i = 1 : M
            K_c(i, j) = rho(j) * beta(j) * Phi(i, j)...
                        * N(i) / N_p(j) * sum(Phi(:, j));
        end
    end
    K_c(:, :) = (diag(alpha + gamma + psi)) \ K_c(:, :);
end