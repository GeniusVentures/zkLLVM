add_custom_target(circuit_cpp_examples)
add_custom_target(assign_cpp_examples)
add_custom_target(prove_cpp_examples)

function(add_example_without_proving example_target)
    set(prefix ARG)
    set(noValues "")
    set(singleValues INPUT)
    set(multiValues SOURCES COMPILER_OPTIONS)
    cmake_parse_arguments(${prefix}
                        "${noValues}"
                        "${singleValues}"
                        "${multiValues}"
                        ${ARGN})
    add_circuit(${example_target}
                SOURCES ${ARG_SOURCES}
                COMPILER_OPTIONS ${ARG_COMPILER_OPTIONS}

                LINK_LIBRARIES
                crypto3::algebra
                crypto3::block
                crypto3::blueprint
                crypto3::codec
                crypto3::containers
                crypto3::hash
                crypto3::kdf
                crypto3::mac
                marshalling::core
                marshalling::crypto3_algebra
                marshalling::crypto3_multiprecision
                marshalling::crypto3_zk
                crypto3::math
                crypto3::modes
                crypto3::multiprecision
                crypto3::passhash
                crypto3::pbkdf
                crypto3::threshold
                crypto3::pkpad
                crypto3::pubkey
                crypto3::random
                crypto3::stream
                crypto3::vdf
                crypto3::zk

                ${Boost_LIBRARIES})
    add_dependencies(circuit_cpp_examples "${example_target}")

    set(binary_name ${example_target}.ll)

    assign_ir(${example_target} ${binary_name} ${ARG_INPUT})
    add_dependencies(assign_cpp_examples ${example_target}_assign)
endfunction()

function(add_example_with_proving example_target)
    set(prefix ARG)
    set(noValues "")
    set(singleValues INPUT)
    set(multiValues SOURCES)
    cmake_parse_arguments(${prefix}
                        "${noValues}"
                        "${singleValues}"
                        "${multiValues}"
                        ${ARGN})

    add_example_without_proving(${example_target} ${ARGN})

    gen_proof(${example_target} ${ARG_INPUT})
    add_dependencies(prove_cpp_examples ${example_target}_prove)

    if(GENERATE_EVM_VERIFIER)
        gen_evm_verifier(${example_target} ${ARG_INPUT})
        add_dependencies(prove_cpp_examples ${example_target}_evm_verifier)
    endif()

endfunction()

add_example_with_proving(arithmetics_cpp_example SOURCES arithmetics.cpp INPUT arithmetics.inp)
add_example_with_proving(integer_arithmetics_cpp_example SOURCES integer_arithmetics.cpp INPUT integer_arithmetics.inp)
add_example_with_proving(poseidon_cpp_example SOURCES poseidon.cpp INPUT poseidon.inp)
add_example_with_proving(merkle_tree_poseidon_cpp_example SOURCES merkle_tree_poseidon.cpp INPUT merkle_tree_poseidon.inp)
add_example_without_proving(merkle_tree_sha2_256_cpp_example SOURCES merkle_tree_sha2_256.cpp INPUT merkle_tree_sha2_256.inp)
add_example_without_proving(validate_merkle_path_sha2_256_cpp_example SOURCES validate_merkle_path_sha2_256.cpp INPUT validate_merkle_path_sha2_256.inp)
add_example_without_proving(sha256_cpp_example SOURCES sha2_256.cpp INPUT sha2_256.inp)
add_example_with_proving(balance_cpp_example SOURCES balance.cpp INPUT balance.inp)
add_example_with_proving(memory_cpp_example SOURCES memory.cpp INPUT memory.inp)
add_example_with_proving(polynomial_cpp_example SOURCES polynomial.cpp INPUT polynomial.inp COMPILER_OPTIONS -std=c++20)
add_example_with_proving(pallas_curve_addition_cpp_example
           SOURCES pallas_curve_examples/pallas_curve_add.cpp
           INPUT pallas_curve_examples/pallas_curve_add.inp)
add_example_with_proving(pallas_curve_multiplication_cpp_example
            SOURCES pallas_curve_examples/pallas_curve_mul.cpp
            INPUT pallas_curve_examples/pallas_curve_mul.inp)
add_example_with_proving(ed25519_curve_add_cpp SOURCES ed25519_curve_add.cpp INPUT ed25519_curve_add.inp)
add_example_with_proving(ed25519_curve_mul_cpp SOURCES ed25519_curve_mul.cpp INPUT ed25519_curve_mul.inp)
add_example_with_proving(ed25519_field_add_cpp SOURCES ed25519_field_add.cpp INPUT ed25519_field_add.inp)
add_example_with_proving(strlen_cpp_example SOURCES strlen.cpp INPUT strlen.inp)
add_example_with_proving(sha2_512_cpp SOURCES sha2_512.cpp INPUT sha2_512.inp)

add_example_with_proving(uint_remainder_cpp SOURCES bit_operations/uint_remainder.cpp INPUT bit_operations/uint_remainder.inp)
add_example_with_proving(uint_division_cpp SOURCES bit_operations/uint_division.cpp INPUT bit_operations/uint_division.inp)
add_example_with_proving(uint_shift_left SOURCES bit_operations/shift_left.cpp INPUT bit_operations/shift_left.inp)
add_example_with_proving(uint_shift_right SOURCES bit_operations/shift_right.cpp INPUT bit_operations/shift_right.inp)
add_example_with_proving(uint_bit_decomposition SOURCES bit_operations/bit_decomposition.cpp INPUT bit_operations/bit_decomposition.inp)
add_example_with_proving(uint_bit_composition SOURCES bit_operations/bit_composition.cpp INPUT bit_operations/bit_composition.inp)

add_example_with_proving(compare_neq_cpp SOURCES compare/neq.cpp INPUT compare/neq.inp)
add_example_with_proving(compare_eq_cpp SOURCES compare/eq.cpp INPUT compare/eq.inp)
# Comparison component is disabled due to issue with negative numbers, so we can't prove an empty circuit
add_example_without_proving(compare_grequal_cpp SOURCES compare/grequal.cpp INPUT compare/grequal.inp)
add_example_without_proving(compare_lequal_cpp SOURCES compare/lequal.cpp INPUT compare/lequal.inp)
add_example_without_proving(compare_greater_than_cpp SOURCES compare/greater_than.cpp INPUT compare/greater_than.inp)
add_example_without_proving(compare_less_than_cpp SOURCES compare/less_than.cpp INPUT compare/less_than.inp)

#Balances tree example is too big to be proven in a reasonable time
add_example_without_proving(balances_tree_cpp_example SOURCES balances_tree.cpp INPUT balances_tree.inp)

add_example_without_proving(eddsa_signature_verification_cpp SOURCES eddsa_signature_verification.cpp INPUT eddsa_signature_verification.inp)
add_example_without_proving(zkbridge_cpp SOURCES zkbridge.cpp INPUT zkbridge.inp)

add_example_with_proving(private_input_cpp SOURCES private_input.cpp INPUT private_input.inp)

add_example_with_proving(fri_lin_inter SOURCES placeholder_prover/fri_lin_inter.cpp INPUT placeholder_prover/fri_lin_inter.inp)
add_example_with_proving(fri_array_swap SOURCES placeholder_prover/fri_array_swap.cpp INPUT placeholder_prover/fri_array_swap.inp)
add_example_with_proving(fri_array_swap_intrinsic SOURCES placeholder_prover/fri_array_swap_intrinsic.cpp INPUT placeholder_prover/fri_array_swap_intrinsic.inp)
add_example_with_proving(fri_cosets SOURCES placeholder_prover/fri_cosets.cpp INPUT placeholder_prover/fri_cosets.inp)
add_example_with_proving(gate_argument_verifier SOURCES placeholder_prover/gate_argument_verifier.cpp INPUT placeholder_prover/gate_argument_verifier.inp)
add_example_with_proving(permutation_argument_verifier SOURCES placeholder_prover/permutation_argument_verifier.cpp INPUT placeholder_prover/permutation_argument_verifier.inp)
add_example_with_proving(lookup_argument_verifier SOURCES placeholder_prover/lookup_argument_verifier.cpp INPUT placeholder_prover/lookup_argument_verifier.inp)
