sigma_xy = 100; %%% um
roll = 100; %%% urad
sigma_strength = 1e-3;

magnets = placet_get_number_list("prae", "quadrupole");
magnets = [ magnets placet_get_number_list("$beamline", "sbend") ];
quads = placet_get_number_list("prae", "quadrupole");
sbends = placet_get_number_list("prae", "sbend");

placet_element_set_attribute("prae", magnets, "xp", randn(size(magnets))*sigma_xy);
placet_element_set_attribute("prae", magnets, "yp", randn(size(magnets))*sigma_xy);
placet_element_set_attribute("prae", magnets, "roll", randn(size(magnets))*roll);
placet_element_set_attribute("prae", magnets, "xp", randn(size(magnets))*roll);
placet_element_set_attribute("prae", magnets, "yp", randn(size(magnets))*roll);

STRENGTH = placet_element_get_attribute("prae", quads, "strength");
placet_element_set_attribute("prae", quads, "strength", STRENGTH.*(1+sigma_strength*randn(size(quads))'));

E0 = placet_element_get_attribute("prae", sbends, "e0");
placet_element_set_attribute("prae", sbends, "e0", E0.*(1+sigma_strength*randn(size(sbends))'));
