/*
 * Copyright(C) 2024 National Technology & Engineering Solutions
 * of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
 * NTESS, the U.S. Government retains certain rights in this software.
 *
 * See packages/seacas/LICENSE for details
 */
#pragma once

#include "ioss_export.h"

#include "Ioss_ChainGenerator.h"
#include "Ioss_CodeTypes.h"
#include "Ioss_Region.h"
#include <string>
#include <vector>

namespace Ioss {
  class IOSS_EXPORT DecompUtils
  {
  public:
    template <typename INT>
    static void line_decomp_modify(const Ioss::chain_t<INT> &element_chains,
                                   std::vector<int> &elem_to_proc, int proc_count);

    template <typename INT>
    static void output_decomposition_statistics(const std::vector<INT> &elem_to_proc,
                                                int proc_count, size_t number_elements);

    template <typename INT>
    static std::vector<float> line_decomp_weights(const Ioss::chain_t<INT> &element_chains,
                                                  size_t                    element_count);

    template <typename INT>
    static int line_decompose(Region &region, size_t num_ranks, const std::string &method,
                              const std::string &surface_list, std::vector<int> &element_to_proc, INT dummy);

    template <typename INT>
    static std::tuple<std::vector<double>, std::vector<double>, std::vector<double>>
    get_element_centroid(const Ioss::Region &region, IOSS_MAYBE_UNUSED INT dummy);
  };
} // namespace Ioss
