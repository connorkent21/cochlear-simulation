import librosa, librosa.display, librosa.output
import matplotlib.pyplot as plt

requested_sample = input("Enter file path to audio file: ")

# Convert to mono and downsample
sample_array, sample_rate = librosa.load(requested_sample, sr=16000, mono=True, duration=30)
sample_duration = librosa.get_duration(y=sample_array, sr=sample_rate)
print("Sample duration: ", sample_duration)
print("Sample: ", sample_array)
print("Sample rate: ", sample_rate)



# Plot the sound file
plt.figure()
plt.subplot(3, 1, 1)
librosa.display.waveplot(sample_array, sr=sample_rate)
plt.title(requested_sample + " - mono")
plt.show()

# Save new file
new_sample = input("Enter new file name: ")
librosa.output.write_wav(new_sample, sample_array, sample_rate)

# Plot cosine signal
plt.figure()
plt.subplot(3, 1, 1)
cosine_map_plot = librosa.tone(1000, sr=sample_rate, duration=0.002)
cosine_map = librosa.tone(1000, sr=sample_rate, duration=sample_duration)
print("Cosine map: ", cosine_map)

# print("Cosine sample rate: ", sample_rate_cosine)
librosa.display.waveplot(cosine_map_plot, sr=sample_rate)
plt.title(requested_sample + " - cosine wave (1KHz)")
plt.show()

# Save Cosine file
cosine_file = input("Enter file name for cosine sample: ")
librosa.output.write_wav(cosine_file, cosine_map, sample_rate)