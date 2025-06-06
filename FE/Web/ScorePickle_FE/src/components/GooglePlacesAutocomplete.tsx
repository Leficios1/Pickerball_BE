import { useState } from 'react';
import { AutoComplete, Input } from 'antd';

const LocationAutoComplete = () => {
  const [options, setOptions] = useState<{ value: string }[]>([]);

  const handleSearch = (value: string) => {
    if (!value || !window.google || !window.google.maps) {
      setOptions([]);
      return;
    }

    const autocompleteService =
      new window.google.maps.places.AutocompleteService();

    autocompleteService.getPlacePredictions(
      {
        input: value,
        componentRestrictions: { country: 'vn' }, // giới hạn theo quốc gia
        types: ['(regions)'], // gợi ý tỉnh/thành, có thể bỏ để đa dạng hơn
      },
      (predictions, status) => {
        if (
          status === window.google.maps.places.PlacesServiceStatus.OK &&
          predictions
        ) {
          const results = predictions.map((p) => ({
            value: p.description,
          }));
          setOptions(results);
        } else {
          setOptions([]);
        }
      }
    );
  };

  return (
    <AutoComplete
      options={options}
      onSearch={handleSearch}
      placeholder="Enter Location..."
      allowClear
    >
      <Input />
    </AutoComplete>
  );
};

export default LocationAutoComplete;
