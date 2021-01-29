// Copyright(C) 1999-2020 National Technology & Engineering Solutions
// of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
// NTESS, the U.S. Government retains certain rights in this software.
//
// See packages/seacas/LICENSE for details

#ifndef IOSS_Ioss_FaceSet_h
#define IOSS_Ioss_FaceSet_h

#include "Ioss_EntityType.h" // for EntityType, etc
#include "Ioss_Property.h"   // for Property
#include <Ioss_EntitySet.h>  // for EntitySet
#include <cstddef>           // for size_t
#include <cstdint>           // for int64_t
#include <string>            // for string
#include <vector>            // for vector
namespace Ioss {
  class DatabaseIO;
} // namespace Ioss
namespace Ioss {
  class Field;
} // namespace Ioss

namespace Ioss {

  /** \brief A collection of element faces.
   */
  class FaceSet : public EntitySet
  {
  public:
    FaceSet(); // Used for template typing only
    FaceSet(const FaceSet &) = default;
    FaceSet(DatabaseIO *io_database, const std::string &my_name, int64_t number_faces);

    std::string type_string() const override { return "FaceSet"; }
    std::string short_type_string() const override { return "facelist"; }
    std::string contains_string() const override { return "Face"; }
    EntityType  type() const override { return FACESET; }

    // Handle implicit properties -- These are calcuated from data stored
    // in the grouping entity instead of having an explicit value assigned.
    // An example would be 'element_block_count' for a region.
    Property get_implicit_property(const std::string &my_name) const override;

    void block_membership(std::vector<std::string> &block_membership) override;
    bool operator==(const FaceSet &); 
    bool operator!=(const FaceSet &); 
    bool equal(const FaceSet &); 

  protected:
    int64_t internal_get_field_data(const Field &field, void *data,
                                    size_t data_size) const override;

    int64_t internal_put_field_data(const Field &field, void *data,
                                    size_t data_size) const override;
  };
} // namespace Ioss
#endif
